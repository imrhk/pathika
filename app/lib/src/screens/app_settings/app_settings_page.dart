import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:url_launcher/url_launcher.dart';

import '../../constants/remote_constants.dart';
import '../../constants/route_constants.dart';
import '../../extensions/context_extensions.dart';
import '../../routes/routes_extra.dart';
import '../../theme/app_theme.dart';
import 'bloc/app_settings_bloc.dart';
import 'bloc/app_settings_event.dart';

class AppSettingsPage extends StatelessWidget {
  final Function? appLanguageChanged;
  final String? currentLanguge;
  final Function? changePlace;

  const AppSettingsPage({
    super.key,
    this.appLanguageChanged,
    this.currentLanguge,
    this.changePlace,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.currentTheme;
    return _SettingsContainer(widgets: [
      _SettingsSectionHeader(
        text: context.l10n.theme,
      ),
      _RadioGroupWidget<String>(
          items: LinkedHashMap.from(
            {
              context.l10n.light: 'light',
              context.l10n.colorful_light: 'colorful_light',
              context.l10n.dark: 'dark',
              context.l10n.colorful_dark: 'colorful_dark',
              context.l10n.gold_dark: 'gold_dark',
            },
          ),
          currentSelection: appTheme.label,
          onSelected: (String? str) {
            if (str == null) {
              context.pop();
              return;
            }
            context
              ..read<AppSettingsBloc>().add(AppSettingsEvent.changeTheme(str))
              ..pop();
          }),
      const _SettingsSectionHeader(text: ''),
      _SettingsTile(
          child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                context.l10n.change_langauge,
                style: TextStyle(
                  color: getThemeTextColor(context),
                ),
              ),
            ),
            Icon(
              Platform.isIOS
                  ? CupertinoIcons.right_chevron
                  : Icons.keyboard_arrow_right,
              color: Platform.isIOS ? CupertinoColors.activeBlue : null,
            ),
          ],
        ),
        onTap: () async {
          context.push(
            '/$selectLanguagePath',
            extra: SelectLanguagePageData(
              previousTitle: context.l10n.settings,
            ),
          );
        },
      )),
      const _SettingsSectionHeader(text: ''),
      _SettingsButton(
        text: context.l10n.privacy_policy,
        onPress: () {
          final uri = Uri.tryParse(privaryPolicyUrl);
          if (uri != null) {
            launchUrl(Uri.parse(privaryPolicyUrl));
          } else {
            // TODO: alert dialog / snackbar based on platform
          }
        },
      ),
    ]);
  }

  Color? getThemeTextColor(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoColors.label.resolveFrom(context);
    } else {
      return Theme.of(context).textTheme.bodyLarge?.color;
    }
  }

  Widget getThemeWidget(Widget child, AppTheme appTheme) {
    if (Platform.isIOS) {
      final theme = appTheme.themeDataCupertino;
      if (theme != null) {
        return CupertinoTheme(data: theme, child: child);
      }
    } else {
      final theme = appTheme.themeDataMaterial;
      if (theme != null) {
        return Theme(data: theme, child: child);
      }
    }
    return Theme(data: ThemeData.light(), child: child);
  }

  PageRoute getPageRoute({required WidgetBuilder builder}) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: builder);
    } else {
      return MaterialPageRoute(builder: builder);
    }
  }
}

class _SettingsContainer extends StatelessWidget with PlatformWidgetMixin {
  const _SettingsContainer({
    required this.widgets,
  });

  final List<Widget> widgets;

  @override
  Widget buildAndroid(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => widgets[index],
      itemCount: widgets.length,
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoSettings(items: widgets);
  }
}

class _RadioGroupWidget<T> extends StatelessWidget with PlatformWidgetMixin {
  const _RadioGroupWidget({
    super.key,
    required this.items,
    required this.onSelected,
    required this.currentSelection,
  });

  final LinkedHashMap<T, T> items;
  final void Function(T? value) onSelected;
  final T? currentSelection;

  @override
  Widget buildAndroid(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.entries
          .map<Widget>((entry) => RadioListTile<T>(
                value: entry.value,
                title: Text(entry.key.toString()),
                groupValue: currentSelection,
                onChanged: onSelected,
              ))
          .toList(),
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CSSelection<T>(
      items: items.entries
          .map(
            (entry) => CSSelectionItem<T>(
                text: entry.key.toString(), value: entry.value),
          )
          .toList(),
      onSelected: (value) => onSelected(value),
      currentSelection: currentSelection,
    );
  }
}

class _SettingsTile extends StatelessWidget with PlatformWidgetMixin {
  @override
  final Widget child;
  const _SettingsTile({
    required this.child,
  });

  @override
  Widget buildAndroid(BuildContext context) {
    return ListTile(
      title: child,
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CSWidget(child);
  }
}

class _SettingsSectionHeader extends StatelessWidget with PlatformWidgetMixin {
  final String text;

  const _SettingsSectionHeader({
    required this.text,
  });

  @override
  Widget buildAndroid(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CSHeader(text);
  }
}

class _SettingsButton extends StatelessWidget with PlatformWidgetMixin {
  final String text;
  final VoidCallback onPress;

  const _SettingsButton({required this.text, required this.onPress});

  @override
  Widget buildAndroid(BuildContext context) => ListTile(
        title: Text(text),
        onTap: onPress,
      );

  @override
  Widget buildIOS(BuildContext context) =>
      CSButton(CSButtonType.DEFAULT, text, onPress);
}
