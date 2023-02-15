import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../extensions/context_extensions.dart';
import '../widgets/titled_page.dart';

part 'routes_extra.g.dart';

mixin PageTitleData {
  String? get titleKey;
  String? get previousTitleKey;
  String get defaultTitle;
  String get defaultPreviousTitle;
}

mixin TitledPageMixin {
  String? pageTitle(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<TitledPage>();
    if (widget != null) {
      if (widget.titleKey != null) {
        return context.localize(widget.titleKey!, widget.defaultTitle);
      }
      return widget.defaultTitle;
    }
    return null;
  }

  String? previousPageTitle(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<TitledPage>();
    var result = '';
    if (widget != null) {
      if (widget.previousTitleKey != null) {
        result = context.localize(
            widget.previousTitleKey!, widget.defaultPreviousTitle);
      }
      result = widget.defaultPreviousTitle;
    }
    if (result.length > 12) {
      return "${result.substring(0, 9)}...";
    } else if (result.isNotEmpty) {
      return result;
    }
    return null;
  }
}

@JsonSerializable()
class PlacesListPageData with PageTitleData {
  @override
  final String defaultPreviousTitle;

  @override
  String get defaultTitle => 'Discover';

  @override
  final String? previousTitleKey;

  @override
  String? get titleKey => '_discover';

  const PlacesListPageData({
    required this.defaultPreviousTitle,
    this.previousTitleKey,
  });

  factory PlacesListPageData.fromJson(Map<String, dynamic> json) =>
      _$PlacesListPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlacesListPageDataToJson(this);
}

@JsonSerializable()
class AppSettingsPageData with PageTitleData {
  @override
  final String defaultPreviousTitle;

  @override
  String get defaultTitle => 'Settings';

  @override
  final String? previousTitleKey;

  @override
  String? get titleKey => '_settings';

  const AppSettingsPageData({
    required this.defaultPreviousTitle,
    this.previousTitleKey,
  });

  factory AppSettingsPageData.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsPageDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsPageDataToJson(this);
}

@JsonSerializable()
class SelectLanguagePageData with PageTitleData {
  @override
  final String defaultPreviousTitle;

  @override
  String get defaultTitle => 'Select Language';

  @override
  final String? previousTitleKey;

  @override
  String? get titleKey => 'select_language';

  const SelectLanguagePageData({
    required this.defaultPreviousTitle,
    this.previousTitleKey,
  });

  factory SelectLanguagePageData.fromJson(Map<String, dynamic> json) =>
      _$SelectLanguagePageDataFromJson(json);

  Map<String, dynamic> toJson() => _$SelectLanguagePageDataToJson(this);
}
