import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../routes/routes_extra.dart';

class TitledPage extends InheritedWidget with PageTitleData {
  @override
  final String title;
  @override
  final String previousTitle;

  TitledPage({
    super.key,
    required this.title,
    required this.previousTitle,
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
      title: data.title,
      previousTitle: data.previousTitle,
      child: child,
    );
  }

  static TitledPage? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<TitledPage>());
  }

  @override
  bool updateShouldNotify(TitledPage oldWidget) {
    return title != oldWidget.title || previousTitle != oldWidget.previousTitle;
  }
}
