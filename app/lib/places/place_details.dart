import 'dart:convert';

import '../airport/airport_details.dart';
import '../basic_info/basic_info.dart';
import '../climate/climate_details.dart';
import '../country/country_details.dart';
import '../currency/currency_details.dart';
import '../dance/dance_details.dart';
import '../famous_people/person_list.dart';
import '../food/food_items_list.dart';
import '../industries/industry_details.dart';
import '../language/language_details.dart';
import '../location_map/location_map_details.dart';
import '../movies/movie_list.dart';
import '../sports/sports_details.dart';
import '../time_to_visit/time_to_visit_details.dart';
import '../tourist_attractions/tourist_attractions.list.dart';
import '../trivia/trivia_list_details.dart';

class PlaceDetails {
  AirportDetails airport;
  BasicInfo basicInfo;
  ClimateDetails climateDetails;
  CountryDetails countryDetails;
  CurrencyDetails currencyDetails;
  DanceDetails danceDetails;
  FoodItemsList foodItemsList;
  IndustryDetails industriesDetails;
  LanguageDetails languageDetails;
  LocationMapDetails locationMapList;
  MovieList moviesList;
  PersonList personsList;
  SportsDetails sportsDetails;
  TimeToVisitDetails timeToVisitDetails;
  int timezoneOffsetInMinutes;
  TouristAttractionsList touristPlacesList;
  TriviaListDetails triviaListDetails;
  PlaceDetails({
    this.airport,
    this.basicInfo,
    this.climateDetails,
    this.countryDetails,
    this.currencyDetails,
    this.danceDetails,
    this.foodItemsList,
    this.industriesDetails,
    this.languageDetails,
    this.locationMapList,
    this.moviesList,
    this.personsList,
    this.sportsDetails,
    this.timeToVisitDetails,
    this.timezoneOffsetInMinutes,
    this.touristPlacesList,
    this.triviaListDetails,
  });

  factory PlaceDetails.empty() {
    return PlaceDetails(
      airport: AirportDetails.empty(),
      basicInfo: BasicInfo.empty(),
      climateDetails: ClimateDetails.empty(),
      countryDetails: CountryDetails.empty(),
      currencyDetails: CurrencyDetails.empty(),
      danceDetails: DanceDetails.empty(),
      foodItemsList: FoodItemsList.empty(),
      industriesDetails: IndustryDetails.empty(),
      languageDetails: LanguageDetails.empty(),
      locationMapList: LocationMapDetails.empty(),
      moviesList: MovieList.empty(),
      personsList: PersonList.empty(),
      sportsDetails: SportsDetails.empty(),
      timeToVisitDetails: TimeToVisitDetails.empty(),
      timezoneOffsetInMinutes: 0,
      touristPlacesList: TouristAttractionsList.empty(),
      triviaListDetails: TriviaListDetails.empty(),
    );
  }

  PlaceDetails copyWith({
    AirportDetails airport,
    BasicInfo basicInfo,
    ClimateDetails climate,
    CountryDetails country,
    CurrencyDetails currency,
    DanceDetails dance,
    FoodItemsList food,
    IndustryDetails industries,
    LanguageDetails language,
    LocationMapDetails locationMap,
    MovieList movies,
    PersonList persons,
    SportsDetails sports,
    TimeToVisitDetails timeToVisit,
    int timezoneOffsetInMunites,
    TouristAttractionsList touristPlaces,
    TriviaListDetails triviaList,
  }) {
    return PlaceDetails(
      airport: airport ?? this.airport,
      basicInfo: basicInfo ?? this.basicInfo,
      climateDetails: climate ?? this.climateDetails,
      countryDetails: country ?? this.countryDetails,
      currencyDetails: currency ?? this.currencyDetails,
      danceDetails: dance ?? this.danceDetails,
      foodItemsList: food ?? this.foodItemsList,
      industriesDetails: industries ?? this.industriesDetails,
      languageDetails: language ?? this.languageDetails,
      locationMapList: locationMap ?? this.locationMapList,
      moviesList: movies ?? this.moviesList,
      personsList: persons ?? this.personsList,
      sportsDetails: sports ?? this.sportsDetails,
      timeToVisitDetails: timeToVisit ?? this.timeToVisitDetails,
      timezoneOffsetInMinutes:
          timezoneOffsetInMunites ?? this.timezoneOffsetInMinutes,
      touristPlacesList: touristPlaces ?? this.touristPlacesList,
      triviaListDetails: triviaList ?? this.triviaListDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'airport': airport.toMap(),
      'basic_info': basicInfo.toMap(),
      'climate': climateDetails.toMap(),
      'country': countryDetails.toMap(),
      'currency': currencyDetails.toMap(),
      'dance': danceDetails.toMap(),
      'food': foodItemsList.toMap(),
      'industries': industriesDetails.toMap(),
      'language': languageDetails.toMap(),
      'location_map': locationMapList.toMap(),
      'movies': moviesList.toMap(),
      'persons': personsList.toMap(),
      'sports': sportsDetails.toMap(),
      'time_to_visit': timeToVisitDetails.toMap(),
      'timezone_offset_in_minutes': timezoneOffsetInMinutes,
      'tourist_places': touristPlacesList.toMap(),
      'trivia': triviaListDetails.toMap(),
    };
  }

  static PlaceDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PlaceDetails(
      airport: AirportDetails.fromMap(map['airport']),
      basicInfo: BasicInfo.fromMap(map['basic_info']),
      climateDetails: ClimateDetails.fromMap(map['climate']),
      countryDetails: CountryDetails.fromMap(map['country']),
      currencyDetails: CurrencyDetails.fromMap(map['currency']),
      danceDetails: DanceDetails.fromMap(map['dance']),
      foodItemsList: FoodItemsList.fromMap(map['food']),
      industriesDetails: IndustryDetails.fromMap(map['industries']),
      languageDetails: LanguageDetails.fromMap(map['language']),
      locationMapList: LocationMapDetails.fromMap(map['location_map']),
      moviesList: MovieList.fromMap(map['movies']),
      personsList: PersonList.fromMap(map['persons']),
      sportsDetails: SportsDetails.fromMap(map['sports']),
      timeToVisitDetails: TimeToVisitDetails.fromMap(map['time_to_visit']),
      timezoneOffsetInMinutes: map['timezone_offset_in_minutes'],
      touristPlacesList: TouristAttractionsList.fromMap(map['tourist_places']),
      triviaListDetails: TriviaListDetails.fromMap(map['trivia']),
    );
  }

  String toJson() => json.encode(toMap());

  static PlaceDetails fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaceDetails airport: $airport, basic_info: $basicInfo, climate: $climateDetails, country: $countryDetails, currency: $currencyDetails, dance: $danceDetails, food: $foodItemsList, industries: $industriesDetails, language: $languageDetails, location_map: $locationMapList, movies: $moviesList, persons: $personsList, sports: $sportsDetails, time_to_visit: $timeToVisitDetails, timezone_offset_in_minutes: $timezoneOffsetInMinutes, tourist_places: $touristPlacesList, triviaListDetails: $triviaListDetails';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlaceDetails &&
        o.airport == airport &&
        o.basicInfo == basicInfo &&
        o.climateDetails == climateDetails &&
        o.countryDetails == countryDetails &&
        o.currencyDetails == currencyDetails &&
        o.danceDetails == danceDetails &&
        o.foodItemsList == foodItemsList &&
        o.industriesDetails == industriesDetails &&
        o.languageDetails == languageDetails &&
        o.locationMapList == locationMapList &&
        o.moviesList == moviesList &&
        o.personsList == personsList &&
        o.sportsDetails == sportsDetails &&
        o.timeToVisitDetails == timeToVisitDetails &&
        o.timezoneOffsetInMinutes == timezoneOffsetInMinutes &&
        o.touristPlacesList == touristPlacesList &&
        o.triviaListDetails == triviaListDetails;
  }

  @override
  int get hashCode {
    return airport.hashCode ^
        basicInfo.hashCode ^
        climateDetails.hashCode ^
        countryDetails.hashCode ^
        currencyDetails.hashCode ^
        danceDetails.hashCode ^
        foodItemsList.hashCode ^
        industriesDetails.hashCode ^
        languageDetails.hashCode ^
        locationMapList.hashCode ^
        moviesList.hashCode ^
        personsList.hashCode ^
        sportsDetails.hashCode ^
        timeToVisitDetails.hashCode ^
        timezoneOffsetInMinutes.hashCode ^
        touristPlacesList.hashCode ^
        triviaListDetails.hashCode;
  }
}
