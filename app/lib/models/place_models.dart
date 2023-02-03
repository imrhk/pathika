import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_models.freezed.dart';
part 'place_models.g.dart';

@freezed
class PlaceDetails with _$PlaceDetails {
  @JsonSerializable(explicitToJson: true)
  const factory PlaceDetails({
    @JsonKey(name: 'airport') AirportDetails? airport,
    @JsonKey(name: 'basic_info') PlaceInfo? basicInfo,
    @JsonKey(name: 'climate') ClimateDetails? climateDetails,
    @JsonKey(name: 'country') CountryDetails? countryDetails,
    @JsonKey(name: 'currency') CurrencyDetails? currencyDetails,
    @JsonKey(name: 'dance') DanceDetails? danceDetails,
    @JsonKey(name: 'food') ItemList<FoodItemDetails>? foodItemsList,
    @JsonKey(name: 'industries') IndustryDetails? industriesDetails,
    @JsonKey(name: 'language') LanguageDetails? languageDetails,
    @JsonKey(name: 'location_map') ItemList<String>? locationMapList,
    @JsonKey(name: 'movies') ItemList<MovieDetails>? moviesList,
    @JsonKey(name: 'persons') ItemList<PersonDetails>? personsList,
    @JsonKey(name: 'sports') SportsDetails? sportsDetails,
    @JsonKey(name: 'time_to_visit') TimeToVisitDetails? timeToVisitDetails,
    @JsonKey(name: 'timezone_offset_in_minutes') int? timezoneOffsetInMinutes,
    @JsonKey(name: 'tourist_places')
        ItemList<TouristAttractionDetails>? touristPlacesList,
    @JsonKey(name: 'trivia') ItemList<String>? triviaListDetails,
  }) = _PlaceDetails;

  factory PlaceDetails.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailsFromJson(json);
}

@freezed
class PlaceInfo with _$PlaceInfo {
  const factory PlaceInfo(
    String name,
    String id,
    @JsonKey(name: 'background_image') String? backgroundImage,
    String? place,
    String? licence,
    @JsonKey(name: 'photo_by') String? photoBy,
    @JsonKey(name: 'attribution_url') String? attributionUrl,
    String? country,
  ) = _PlaceInfo;

  factory PlaceInfo.fromJson(Map<String, dynamic> json) =>
      _$PlaceInfoFromJson(json);
}

@freezed
class AirportDetails with _$AirportDetails {
  const factory AirportDetails({
    required String name,
  }) = _AirportDetails;

  factory AirportDetails.fromJson(Map<String, dynamic> json) =>
      _$AirportDetailsFromJson(json);
}

@freezed
class ClimateDetails with _$ClimateDetails {
  const factory ClimateDetails({
    required String type,
    required List<WeatherItem> items,
  }) = _ClimateDetails;

  factory ClimateDetails.fromJson(Map<String, dynamic> json) =>
      _$ClimateDetailsFromJson(json);
}

@freezed
class CountryDetails with _$CountryDetails {
  const factory CountryDetails({
    required String name,
    required String continent,
  }) = _CountryDetails;

  factory CountryDetails.fromJson(Map<String, dynamic> json) =>
      _$CountryDetailsFromJson(json);
}

@freezed
class CurrencyDetails with _$CurrencyDetails {
  const factory CurrencyDetails({
    required String symbol,
    required String name,
    required String code,
  }) = _CurrencyDetails;

  factory CurrencyDetails.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDetailsFromJson(json);
}

@freezed
class DanceDetails with _$DanceDetails {
  const factory DanceDetails({
    @JsonKey(name: 'name') required String title,
  }) = _DanceDetails;

  factory DanceDetails.fromJson(Map<String, dynamic> json) =>
      _$DanceDetailsFromJson(json);
}

@freezed
@JsonSerializable(genericArgumentFactories: true)
class ItemList<T> with _$ItemList<T> {
  const ItemList._();
  const factory ItemList({
    @JsonKey(name: 'items') required List<T> items,
  }) = _ItemList<T>;

  factory ItemList.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$ItemListFromJson<T>(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return _$ItemListToJson<T>(this, toJsonT);
  }
}

@freezed
class FoodItemDetails with _$FoodItemDetails {
  const factory FoodItemDetails({
    required String label,
    String? photo,
    @JsonKey(name: 'is_veg') @Default(false) bool isVeg,
    @JsonKey(name: 'is_non_veg') @Default(false) bool isNonVeg,
    @JsonKey(name: 'photo_by') String? photoBy,
    String? licence,
    @JsonKey(name: 'attribution_url') String? attributionUrl,
  }) = _FoodItemDetails;

  factory FoodItemDetails.fromJson(Map<String, dynamic> json) =>
      _$FoodItemDetailsFromJson(json);
}

@freezed
class IndustryDetails with _$IndustryDetails {
  const factory IndustryDetails({
    required String primary,
    List<String>? secondary,
  }) = _IndustryDetails;

  factory IndustryDetails.fromJson(Map<String, dynamic> json) =>
      _$IndustryDetailsFromJson(json);
}

@freezed
class LanguageDetails with _$LanguageDetails {
  const factory LanguageDetails({
    required String primary,
    @Default([]) List<String> secondary,
  }) = _LangugeDetails;

  factory LanguageDetails.fromJson(Map<String, dynamic> json) =>
      _$LanguageDetailsFromJson(json);
}

@freezed
class MovieDetails with _$MovieDetails {
  const factory MovieDetails({
    required String title,
    String? posterUrl,
  }) = _MovieDetails;

  factory MovieDetails.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsFromJson(json);
}

@freezed
class PersonDetails with _$PersonDetails {
  const factory PersonDetails({
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? work,
    String? place,
    String? licence,
    @JsonKey(name: 'photo_by') String? photoBy,
    @JsonKey(name: 'attribution_url') String? attributionUrl,
  }) = _PersonDetails;

  factory PersonDetails.fromJson(Map<String, dynamic> json) =>
      _$PersonDetailsFromJson(json);
}

@freezed
class SportsDetails with _$SportsDetails {
  const factory SportsDetails({
    String? title,
    String? footer,
  }) = _SportsDetails;

  factory SportsDetails.fromJson(Map<String, dynamic> json) =>
      _$SportsDetailsFromJson(json);
}

@freezed
class TimeToVisitDetails with _$TimeToVisitDetails {
  const factory TimeToVisitDetails({
    required String primary,
    String? secondary,
  }) = _TimeToVisitDetails;

  factory TimeToVisitDetails.fromJson(Map<String, dynamic> json) =>
      _$TimeToVisitDetailsFromJson(json);
}

@freezed
class TouristAttractionDetails with _$TouristAttractionDetails {
  const factory TouristAttractionDetails({
    required String name,
    @JsonKey(name: 'place_id') required String placeId,
    String? description,
    String? photos,
    @JsonKey(name: 'html_attributions') List<String>? attributionUrl,
    String? licence,
  }) = _TouristAttractionDetails;

  factory TouristAttractionDetails.fromJson(Map<String, dynamic> json) =>
      _$TouristAttractionDetailsFromJson(json);
}

@freezed
class WeatherItem with _$WeatherItem {
  const factory WeatherItem({
    required String emoji,
    required String name,
    required String temp,
    required String duration,
  }) = _WeatherItem;

  factory WeatherItem.fromJson(Map<String, dynamic> json) =>
      _$WeatherItemFromJson(json);
}
