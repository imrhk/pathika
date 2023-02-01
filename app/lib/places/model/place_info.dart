import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'place_info.g.dart';

@immutable
@JsonSerializable()
class PlaceInfo extends Equatable {
  final String name;
  final String id;
  @JsonKey(name: 'background_image')
  final String? backgroundImage;
  final String? place;
  final String? licence;
  @JsonKey(name: 'photo_by')
  final String? photoBy;
  @JsonKey(name: 'attribution_url')
  final String? attributionUrl;
  final String? country;

  const PlaceInfo({
    required this.name,
    required this.id,
    this.backgroundImage,
    this.place,
    this.licence,
    this.photoBy,
    this.attributionUrl,
    this.country,
  });

  @override
  List<Object?> get props => [
        name,
        id,
        backgroundImage,
        place,
        licence,
        photoBy,
        attributionUrl,
        country,
      ];

  factory PlaceInfo.fromJson(Map<String, dynamic> json) =>
      _$PlaceInfoFromJson(json);

  Map<String, dynamic> toMap() => _$PlaceInfoToJson(this);

  @override
  String toString() {
    return "PlaceInfo ${_$PlaceInfoToJson(this)}";
  }
}
