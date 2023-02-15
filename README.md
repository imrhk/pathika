# Pathika
App about beautiful places 

Play Store link: https://play.google.com/store/apps/details?id=com.litedevs.pathika.android

# Compilation
To compile the android app:
1. link it to firebase project which will generate firebase_options.dart
2. provide ads config (for android, ios) or ads folder locally and remove reference to ads in the app.
   1. create app/lib/ads/ads_secret.dart
   2. create constants
        ```dart
        const androidAdConfig = AdConfig(
            appId: '<app_id_from_google_ads>',
            adsId: {placesBottomBarPromo: '<ad_id_from_google_ad>'});
        ```
3. Run firebase hosting from cdn folder with `firebase emulators:start` command
4. Replace app/lib/common/constants.dart base url with url provided by firebase emulator or remove if check and use https://cdn.pathika.litedevs.com
5. Run the app in debug mode on android/ios. Release mode requires some files which are not there. 

# Secrets
Some secret files are required to make the app full operational.
There is a folder named secret at top level which isn't committed to Git due to security reasons. Following files are there in it
- AuthKey_XXXXXXXXXXX.p8
- GOOGLE_COULD_API_KEY.txt
- android_signing_secret.properties
- apple-distribution-certificate.p12
- deployment_cert.der
- google-services.json
- XXXXXXXX.keystore
- pathika-XXXXXXXXXXXX.json
- pathika_aab.keystore
  
Apart from that, there are two more files which are not checked in
- tools/pathika_google_places_tool/pathika_google_places_tool/lib/secrets.dart
- tools/translation_parser/data/FCM_SERVER_KEY.txt

The project was build in Jan 2020 when I started learning flutter. I have migrated it to flutter 3.7.0. 

# TODOs
- Flutter Upgrade ✅
- Android upgrade ✅
- Bloc based architecture ✅
- Freezed Model classes ✅
- Retrofit ✅
- Gold theme ✅
- Caching ✅
- Context extensions ✅
- Hive ✅
- Go Router ✅
- Adaptive Widgets ✅
- Logging ✅
- Widgets composition ✅
- Theme Extensions ✅
- Navigation ✅
- Cupertino Page ✅
- Firebase functions migration ✅
- Cupertino (iOS Related) ✅
- Folder Structure ✅
- Localization
- Neon Theme
- Custom Theme
- Theme for Icons and other widgets
- Transition
- Analytics
- Crashlytics 
- Unit Tests
- Widget Tests
- Integration Tests
- Notifications
- Launch Animation
- Web Support 
- iPad Support
- Windows Support
- Mac Support
- Linux Support
- Material3
- WidgetBook.io
- Tappable (read out loud content of cards)
- Zoned

# Licence
Apache License 2.0
