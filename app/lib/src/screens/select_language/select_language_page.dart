import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';
import 'package:universal_io/io.dart' show Platform;

import '../../blocs/page_fetch/page_fetch_state.dart';
import '../../data/assets/assets_repository.dart';
import '../../data/remote/remote_repository.dart';
import '../../extensions/context_extensions.dart';
import '../../models/app_language/app_language.dart';
import '../../routes/routes_extra.dart';
import '../../widgets/adaptive_circular_loader.dart';
import '../../widgets/adaptive_scaffold.dart';
import '../../widgets/material_card.dart';
import '../app_settings/bloc/app_settings_bloc.dart';
import '../app_settings/bloc/app_settings_event.dart';
import 'bloc/app_language_list_bloc.dart';
import 'bloc/app_language_list_event.dart';

class SelectLanguagePage extends StatelessWidget with TitledPageMixin {
  const SelectLanguagePage({
    super.key,
  });

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

  Widget _loadingBuilder() {
    return const AdaptiveScaffold(
        body: Center(
      child: AdaptiveCircularLoader(),
    ));
  }

  Widget _errorBuilder(Error error) {
    return Builder(builder: (context) {
      final errorOccured = context.l10n.error_occured;
      final msg = '$errorOccured\n${error.toString()}';
      return Center(child: Text(msg));
    });
  }

  Widget _loadedBuilder(List<AppLanguage> data) {
    return Builder(
      builder: (context) {
        final themeData = context.currentTheme.themeDataMaterial;
        final Widget child;
        if (themeData == null) {
          child = _buildLanguageList(context, data);
        } else {
          child =
              Theme(data: themeData, child: _buildLanguageList(context, data));
        }
        return AdaptiveScaffold(
          appbar: AppBar(
            title: Text(
              context.l10n.select_language,
            ),
          ),
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              pageTitle(context) ?? '',
            ),
            previousPageTitle: previousPageTitle(context),
          ),
          body: child,
        );
      },
    );
  }

  Widget _buildLanguageList(BuildContext context, List<AppLanguage> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 225,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (ctx, index) => _LanguageListTile(
          key: ValueKey(items[index].id),
          item: items[index],
        ),
        itemCount: items.length,
      ),
    );
  }
}

class _LanguageListTile extends StatelessWidget {
  final AppLanguage item;

  const _LanguageListTile({super.key, required this.item});

  _saveAppLanguage(BuildContext context, AppLanguage language) async {
    context
        .read<AppSettingsBloc>()
        .add(AppSettingsEvent.changeLanguage(language.id, language.rtl));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: const EdgeInsets.all(10),
      elevation: 6,
      shadowColor: _getColorForTheme(context, item.color),
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
        child: _LanguageItem(
            onTap: () => _saveAppLanguage(context, item),
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: _getThemeTextColor(context),
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
            )),
      ),
    );
  }

  Color? _getThemeTextColor(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoColors.label.resolveFrom(context);
    } else {
      return Theme.of(context).textTheme.bodyLarge?.color;
    }
  }

  Color _getColorForTheme(BuildContext context, List<int> argb) {
    Color color = Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
    bool isDark =
        context.currentTheme.themeDataMaterial?.brightness == Brightness.dark;
    Gradient? gradient = context.textGradient;
    if (gradient != null) {
      return gradient.colors.first;
    }
    if (isDark) {
      return HSLColor.fromColor(color)
          .withSaturation(1.0)
          .withLightness(0.5)
          .toColor();
    } else {
      return color;
    }
  }
}

class _LanguageItem extends StatelessWidget with PlatformWidgetMixin {
  @override
  final Widget? child;
  final VoidCallback? onTap;

  const _LanguageItem({
    required this.child,
    required this.onTap,
  });

  @override
  Widget buildAndroid(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}
