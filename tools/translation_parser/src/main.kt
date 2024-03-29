import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.net.URL
import java.net.URLEncoder

const val DEFAULT_LANGUAGE = "en"   
const val SECRET_KEY = "./data/GOOGLE_COULD_API_KEY.txt"
const val CACHE_PREFIX = "P_"

val NO_TRANSLATION = listOf("place_id", "emoji", "symbol", "photo_by", "id", "movies", "code")

var totalApiCalls = 0
var totalCachedCalls = 0
var totalMapsCalls = 0
var totalMapsCachedCalls = 0

fun main() {
    val places = JSONArray(File("./data/input/places.json").readText())
    //val places = JSONArray("[\"buenos_aires\"]")
    //create the master file
    val masterFile = File("./data/output/translations_$DEFAULT_LANGUAGE.json")
    val masterMap = mutableMapOf<String, Any>()
    places.forEach {place ->
        val placeDetails = File("./data/input/$place/details_$DEFAULT_LANGUAGE.json")
        getEntries(placeDetails)
            .forEach {entry ->
                masterMap.putIfAbsent(entry.key, entry.value);
            }
        processMapData(place.toString(), DEFAULT_LANGUAGE, placeDetails);
    }

    getEntries(File("./data/app_localization/$DEFAULT_LANGUAGE.json"))
        .forEach { entry -> masterMap.putIfAbsent(entry.key, entry.value) }

    val masterJson = JSONObject()
    masterMap.filterNot { it.value is String && ((it.value as String).startsWith("http") || (it.value as String).contains("href")) }
        .entries.forEach {entry->
        masterJson.put(entry.value.toString(), entry.value)
    }

    masterFile.writeText(masterJson.toString(4))

    val languages = JSONArray(File("./data/input/languages.json").readText())
        .let { return@let List<String> (it.length()) {index -> it.getJSONObject(index).getString("id") } }.filterNot { it == DEFAULT_LANGUAGE }.toList()

    //val languages = listOf("fr")

    languages.forEach {language->
        val translationFile = File("./data/output/translations_$language.json")
        val translationJson = if (translationFile.exists())  JSONObject(File("./data/output/translations_$language.json").readText()) else JSONObject()
        val requiredKeys = masterJson.keySet() subtract translationJson.keySet()

        requiredKeys.forEach {key->
            val response = getResponse(key, language)
            val responseJson = JSONObject(response)
            val data = responseJson.getJSONObject("data")
            val translations = data.getJSONArray("translations")
            val translatedText = translations.getJSONObject(0).getString("translatedText")
            translationJson.put(key, translatedText)
        }

        translationFile.writeText(translationJson.toString())
    }

    languages.forEach {language ->
        val translationFile = File("./data/output/translations_$language.json")
        val translationJson = if (translationFile.exists())  JSONObject(translationFile.readText()) else JSONObject()

        val copyTranslatedContent = { sourceFile : File, targetFile: File ->
            var targetFileContent = sourceFile.readText()
            translationJson.keySet().forEach {key ->
                targetFileContent = targetFileContent.replace("\"$key\"", "\"${translationJson.getString(key)}\"")
            }
            targetFile.writeText(targetFileContent)
        }

        places.forEach {place->
            val sourceFile = File("./data/input/$place/details_$DEFAULT_LANGUAGE.json")
            val targetFile = File("./data/output/release/$place/details_$language.json")
            copyTranslatedContent(sourceFile, targetFile)
            processMapData(place.toString(), language, targetFile)
        }

        val sourceFile = File("./data/app_localization/$DEFAULT_LANGUAGE.json")
        val targetFile = File("./data/app_localization/$language.json")
        copyTranslatedContent(sourceFile, targetFile)

        val remoteTargetFile = File("./data/output/release/localization_$language.json")
        targetFile.copyTo(remoteTargetFile, overwrite = true)

        val placesListSourceFile = File("./data/input/places_$DEFAULT_LANGUAGE.json")
        val placesListTargetFile = File("./data/input/places_$language.json")
        copyTranslatedContent(placesListSourceFile, placesListTargetFile)

    }




    println("Total Api Calls: $totalApiCalls")
    println("Total Cached Calls: $totalCachedCalls")

    println("Total Maps Api Calls: $totalMapsCalls")
    println("Total Maps Cached Calls: $totalMapsCachedCalls")
}

fun getResponse(text : String, language: String) : String {
    val secretKey = File(SECRET_KEY).readText().replace("\n", "")
    val url = "https://translation.googleapis.com/language/translate/v2?target=$language&key=$secretKey&format=text&q=${URLEncoder.encode(text, "utf-8")}"
    val hashCode = url.hashCode()
    val cacheFile = File("./data/cache/$CACHE_PREFIX$hashCode")
    return if(cacheFile.exists()) {
        totalCachedCalls++
        val content = cacheFile.readText()
        val contentJson = JSONObject(content)
        contentJson.getString("data")
    }
    else {
        totalApiCalls++
        val response = URL(url).readText()
        val contentJson = JSONObject()
        contentJson.put("url", url)
        contentJson.put("data", response)
        cacheFile.writeText(contentJson.toString())
        response
    }
}

fun getEntries(file : File) : Map<String, Any> {
    val rootJson = JSONObject(file.readText())
    return getEntries(rootJson)
}

fun getEntries(jsonObject: JSONObject) : Map<String, Any> {
    val map = mutableMapOf<String, Any>()
    jsonObject.keySet().forEach {key ->
        if(NO_TRANSLATION.contains(key))
            return@forEach
        when (val value = jsonObject.get(key)) {
            is String -> {
                map[value.toLowerCase().replace(' ', '_')] = value
            }
            is JSONObject -> {
                map.putAll(getEntries(value))
            }
            is JSONArray -> {
                map.putAll(getEntries(value))
            }
        }
    }
    return map
}

fun getEntries(jsonArray: JSONArray) : Map<String, Any> {
    val map = mutableMapOf<String, Any>()
    jsonArray.forEach {value ->
        when (value) {
            is String -> {
                map[value.toLowerCase().replace(' ', '_')] = value
            }
            is JSONObject -> {
                map.putAll(getEntries(value))
            }
            is JSONArray -> {
                map.putAll(getEntries(value))
            }
        }
    }
    return map
}

fun processMapData(place: String, language: String, outputFile: File) {
    val mapDataFile = File("./data/input/$place/mapdata.json")
    if(!mapDataFile.exists())
        return
    val secretKey = File(SECRET_KEY).readText().replace("\n", "")
    val levels = JSONArray(mapDataFile.readText())
    for(i in 0 until levels.length()) {
        val level = levels.getJSONObject(i)
        val centerJson = level.getJSONArray("center")
        val zoom = level.getInt("zoom")
        val marker = level.getJSONArray("marker")

        val centerLat = centerJson.getDouble(0)
        val centerLang = centerJson.getDouble(1)

        val markerLat =marker.getDouble(0)
        val markerLang = marker.getDouble(1)

        val url = "https://maps.googleapis.com/maps/api/staticmap?center=$centerLat,$centerLang&zoom=$zoom&size=515x300&maptype=terrain&markers=color:yellow%7C$markerLat,$markerLang&key=$secretKey&language=$language&scale=2"
        val hashCode = url.hashCode()
        val cacheFile = File("./data/cache/$CACHE_PREFIX$hashCode")
        val imageFileName = "${place}_map_${language}_${i+1}.png"
        if(cacheFile.exists()) {
            totalMapsCachedCalls++
            cacheFile.copyTo(File("./data/images/$imageFileName"), overwrite = true)
        }
        else {
            totalMapsCalls++
            val response = URL(url).readBytes()
            cacheFile.writeBytes(response)
            cacheFile.copyTo(File("./data/images/$imageFileName"), overwrite = true)
        }

        val content = outputFile.readText()
        val newContent = content.replace("${place}_map_${DEFAULT_LANGUAGE}_${i+1}.png", imageFileName)
        outputFile.writeText(newContent)
    }

}
