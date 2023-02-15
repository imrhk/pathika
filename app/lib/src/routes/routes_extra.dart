import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../widgets/titled_page.dart';

part 'routes_extra.g.dart';

mixin PageTitleData {
  String get title;
  String get previousTitle;
}

mixin TitledPageMixin {
  String? pageTitle(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TitledPage>()?.title;

  String? previousPageTitle(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<TitledPage>()?.previousTitle;
    if ((result?.length ?? 0) > 12) {
      return "${result!.substring(0, 9)}...";
    } else if (result!.isNotEmpty) {
      return result;
    }
    return null;
  }
}

@JsonSerializable()
class PlacesListPageData with PageTitleData {
  @override
  final String previousTitle;

  @override
  String get title => 'Discover';

  const PlacesListPageData({
    required this.previousTitle,
  });

  factory PlacesListPageData.fromJson(Map<String, dynamic> json) =>
      _$PlacesListPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlacesListPageDataToJson(this);
}

@JsonSerializable()
class AppSettingsPageData with PageTitleData {
  @override
  final String previousTitle;

  @override
  String get title => 'Settings';

  const AppSettingsPageData({
    required this.previousTitle,
  });

  factory AppSettingsPageData.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsPageDataToJson(this);
}

@JsonSerializable()
class SelectLanguagePageData with PageTitleData {
  @override
  final String previousTitle;

  @override
  String get title => 'Select Language';

  const SelectLanguagePageData({
    required this.previousTitle,
  });

  factory SelectLanguagePageData.fromJson(Map<String, dynamic> json) =>
      _$SelectLanguagePageDataFromJson(json);

  Map<String, dynamic> toJson() => _$SelectLanguagePageDataToJson(this);
}
