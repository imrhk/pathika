import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'routes_extra.dart';

class TitledPage extends InheritedWidget with PageTitleData {
  @override
  final String? titleKey;
  @override
  final String? previousTitleKey;
  @override
  final String defaultTitle;
  @override
  final String defaultPreviousTitle;

  TitledPage({
    super.key,
    this.titleKey,
    this.previousTitleKey,
    required this.defaultTitle,
    required this.defaultPreviousTitle,
    required super.child,
  });

  factory TitledPage.goRouterState({
    Key? key,
    required GoRouterState state,
    required Widget child,
  }) {
    if (state.extra is! PageTitleData) {
      assert(false, "state should be titled page");
    }
    final data = state.extra as PageTitleData;
    return TitledPage(
      key: key,
      titleKey: data.titleKey,
      defaultTitle: data.defaultTitle,
      previousTitleKey: data.previousTitleKey,
      defaultPreviousTitle: data.defaultPreviousTitle,
      child: child,
    );
  }

  static TitledPage? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<TitledPage>());
  }

  @override
  bool updateShouldNotify(TitledPage oldWidget) {
    return titleKey != oldWidget.titleKey ||
        previousTitleKey != oldWidget.previousTitleKey ||
        defaultTitle != oldWidget.defaultTitle ||
        defaultPreviousTitle != oldWidget.defaultPreviousTitle;
  }
}
