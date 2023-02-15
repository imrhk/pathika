import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_country.freezed.dart';
part 'user_country.g.dart';

@freezed
class UserCountry with _$UserCountry {
  const factory UserCountry(
    @JsonKey(name: "countryCode") String code,
    @JsonKey(name: "country") String name,
  ) = _UserCountry;

  factory UserCountry.fromJson(Map<String, dynamic> json) =>
      _$UserCountryFromJson(json);
}
