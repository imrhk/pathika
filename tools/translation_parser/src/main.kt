import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.net.URL
import java.net.URLEncoder

const val DEFAULT_LANGUAGE = "en"
const val SECRET_KEY = "./data/GOOGLE_COULD_API_KEY.txt"
const val CACHE_PREFIX = "P_"

val NO_TRANSLATION = listOf("place_id", "emoji", "symbol", "photo_by", "id", "movies")

var totalApiCalls = 0
var totalCachedCalls = 0

fun main() {
    //val places = JSONArray(File("./data/input/places.json").readText())
    val places = JSONArray("[\"buenos_aires\"]")
    //create the master file
    val masterFile = File("./data/output/translations_$DEFAULT_LANGUAGE.json")
    val masterMap = mutableMapOf<String, Any>()
    places.forEach {place ->
        getEntries(File("./data/input/$place/details_$DEFAULT_LANGUAGE.json"))
            .forEach {entry ->
                masterMap.putIfAbsent(entry.key, entry.value);
            }
    }

    val masterJson = JSONObject()
    masterMap.filterNot { it.value is String && ((it.value as String).startsWith("http") || (it.value as String).contains("href")) }
        .entries.forEach {entry->
        masterJson.put(entry.value.toString(), entry.value)
    }

    masterFile.writeText(masterJson.toString(4))

    val languages = JSONArray(File("./data/input/languages.json").readText())
        .let { return@let List<String> (it.length()) {index -> it.getJSONObject(index).getString("id") } }.filterNot { it == DEFAULT_LANGUAGE }.toList()


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
        val translationJson = if (translationFile.exists())  JSONObject(File("./data/output/translations_$language.json").readText()) else JSONObject()

        places.forEach {place->
            val sourceFile = File("./data/input/$place/details_$DEFAULT_LANGUAGE.json")
            val targetFile = File("./data/output/release/$place/details_$language.json")
            var targetFileContent = sourceFile.readText()
            translationJson.keySet().forEach {key ->
                targetFileContent = targetFileContent.replace("\"$key\"", "\"${translationJson.getString(key)}\"")
            }
            targetFile.writeText(targetFileContent)
        }
    }

    println("Total Api Calls: $totalApiCalls")
    println("Total Cached Calls: $totalCachedCalls")
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
        contentJson.getJSONObject("data").toString()
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
