import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart' show Platform;

import '../assets/assets_repository.dart';
import '../common/material_card.dart';
import '../common/widgets/adaptive_app_bar.dart';
import '../common/widgets/adaptive_circular_loader.dart';
import '../localization/localization.dart';
import '../models/app_language.dart';
import '../page_fetch/page_fetch_state.dart';
import '../remote/remote_repository.dart';
import '../screens/app_settings/app_settings_bloc.dart';
import '../screens/app_settings/app_settings_event.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_bloc.dart';
import 'app_language_list_bloc.dart';
import 'app_language_list_event.dart';

class SelectLanguagePage extends StatelessWidget {
  const SelectLanguagePage({
    super.key,
  });

  _saveAppLanguage(BuildContext context, AppLanguage language) async {
    context
        .read<AppSettingsBloc>()
        .add(AppSettingsEvent.changeLanguage(language.id, language.rtl));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppLanguageListBloc>(
      create: (context) {
        const source = kDebugMode
            ? AppLanguageDataSource.local()
            : AppLanguageDataSource.remote();
        return AppLanguageListBloc(
          context.read<RemoteRepository>(),
          context.read<AssetsRepository>(),
        )..add(const AppLanguageListEvent(source, true));
      },
      child:
          BlocBuilder<AppLanguageListBloc, PageFetchState<List<AppLanguage>>>(
        builder: (context, state) {
          return state.when(
              uninitialized: _loadingBuilder,
              loaded: _loadedBuilder,
              loading: _loadingBuilder,
              error: _errorBuilder);
        },
      ),
    );
  }

  Color getColorForTheme(AppTheme appTheme, List<int> argb) {
    Color color = Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
    bool isDark = appTheme.themeDataMaterial?.brightness == Brightness.dark;
    if (isDark) {
      return HSLColor.fromColor(color)
          .withSaturation(1.0)
          .withLightness(0.5)
          .toColor();
    } else {
      return color;
    }
  }

  Widget buildLanguageList(BuildContext context, List<AppLanguage> items) {
    final appTheme = context.read<AppThemeBloc>().state.appTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 60),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 225,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (ctx, index) {
          final item = items[index];
          return MaterialCard(
            margin: const EdgeInsets.all(10),
            elevation: 6,
            shadowColor: getColorForTheme(appTheme, item.color),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Card(
              margin: const EdgeInsets.all(0),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: getLanguageItem(
                onTap: () {
                  _saveAppLanguage(context, item);
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withAlpha(16)),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        item.name ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: getThemeTextColor(context),
                            ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Text(
                          item.msg ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }

  Widget getLanguageItem({Widget? child, VoidCallback? onTap}) {
    if (Platform.isIOS) {
      return GestureDetector(
        onTap: onTap,
        child: child,
      );
    } else {
      return InkWell(
        onTap: onTap,
        child: child,
      );
    }
  }

  Color? getThemeTextColor(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoColors.label.resolveFrom(context);
    } else {
      return Theme.of(context).textTheme.bodyLarge?.color;
    }
  }

  Widget _loadingBuilder() {
    return const AdaptiveScaffold(
        body: Center(
      child: AdaptiveCircularLoader(),
    ));
  }

  Widget _errorBuilder(Error error) {
    return Builder(builder: (context) {
      final errorOccured = context
          .read<LocalizationBloc>()
          .localize('error_occured', 'Error occured');
      final msg = '$errorOccured\n${error.toString()}';
      return Center(child: Text(msg));
    });
  }

  Widget _loadedBuilder(List<AppLanguage> data) {
    return Builder(builder: (context) {
      final appTheme = context.read<AppThemeBloc>().state.appTheme;
      getAppBar() {
        return AppBar(
          title: Text(
            BlocProvider.of<LocalizationBloc>(context)
                .localize('select_language', 'Select Language'),
          ),
        );
      }

      getNavigationBar() {
        return CupertinoNavigationBar(
          leading: GestureDetector(
            child: Row(
              children: <Widget>[
                const Icon(CupertinoIcons.left_chevron,
                    color: CupertinoColors.activeBlue),
                Text(
                  BlocProvider.of<LocalizationBloc>(context)
                      .localize('_settings', 'Settings'),
                  style: const TextStyle(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          middle: Text(
            BlocProvider.of<LocalizationBloc>(context)
                .localize('select_language', 'Select Language'),
          ),
        );
      }

      final themeData = appTheme.themeDataMaterial;
      final Widget child;
      if (themeData == null) {
        child = buildLanguageList(context, data);
      } else {
        child = Theme(data: themeData, child: buildLanguageList(context, data));
      }
      return AdaptiveScaffold(
        getAppBar: getAppBar,
        getNavigationbar: getNavigationBar,
        body: child,
      );
    });
  }
}
