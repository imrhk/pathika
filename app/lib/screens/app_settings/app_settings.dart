import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:url_launcher/url_launcher.dart';

import '../../app_language/select_language_page.dart';
import '../../common/constants.dart';
import '../../localization/localization_bloc.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_theme_bloc.dart';
import '../../theme/app_theme_event.dart';

class AppSettings extends StatelessWidget {
  final Function? appLanguageChanged;
  final String? currentLanguge;
  final Function? changePlace;

  const AppSettings({
    super.key,
    this.appLanguageChanged,
    this.currentLanguge,
    this.changePlace,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = BlocProvider.of<AppThemeBloc>(context).state.appTheme;
    return getSettingsContainer(
      widgets: [
        getSettingsSectionHeader(
          BlocProvider.of<LocalizationBloc>(context).localize('theme', 'Theme'),
        ),
        getRadioGroupWidget(
            items: LinkedHashMap.from(
              {
                BlocProvider.of<LocalizationBloc>(context)
                    .localize('light', 'Light'): AppTheme.light(),
                BlocProvider.of<LocalizationBloc>(context)
                        .localize('colorful_light', 'Colorful Light'):
                    AppTheme.colorfulLight(),
                BlocProvider.of<LocalizationBloc>(context)
                    .localize('dark', 'Dark'): AppTheme.dark(),
                BlocProvider.of<LocalizationBloc>(context).localize(
                    'colorful_dark', 'Colorful Dark'): AppTheme.colorfulDark(),
                BlocProvider.of<LocalizationBloc>(context)
                    .localize('gold_dark', 'Gold Dark'): AppTheme.goldDark(),
              },
            ),
            currentSelection: appTheme,
            onSelected: (appTheme) {
              BlocProvider.of<AppThemeBloc>(context)
                  .add(ChangeAppTheme(appTheme));
              Navigator.pop(context);
            }),
        getSettingsSectionHeader(''),
        getSettingsWidgets(GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  BlocProvider.of<LocalizationBloc>(context)
                      .localize('change_langauge', 'Change Language'),
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
            final response = await Navigator.of(context).push(
              getPageRoute(
                builder: (ctx) =>
                    getThemeWidget(const SelectLanguagePage(), appTheme),
              ),
            );
            if (response != null) {
              appLanguageChanged?.call(response);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            } else {
              if (!Platform.isIOS) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            }
          },
        )),
        getSettingsSectionHeader(''),
        getSettingsButton(
          text: BlocProvider.of<LocalizationBloc>(context)
              .localize('privacy_policy', 'Privacy Policy'),
          onPress: () {
            launchUrl(Uri.parse(privaryPolicyUrl));
          },
        ),
      ],
    );
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

  Widget getSettingsContainer({
    required List<Widget> widgets,
  }) {
    if (Platform.isIOS) {
      return CupertinoSettings(items: widgets);
    } else {
      return ListView.builder(
        itemBuilder: (ctx, index) => widgets[index],
        itemCount: widgets.length,
      );
    }
  }

  Widget getSettingsSectionHeader(String text) {
    if (Platform.isIOS) {
      return CSHeader(text);
    } else {
      if (text.isEmpty) return const SizedBox.shrink();
      return ListTile(
        title: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }
  }

  Widget getRadioGroupWidget<T>({
    required LinkedHashMap<String, T> items,
    required Function(T?) onSelected,
    required T currentSelection,
  }) {
    if (Platform.isIOS) {
      return CSSelection<T>(
        items: items.entries
            .map((entry) =>
                CSSelectionItem<T>(text: entry.key, value: entry.value))
            .toList(),
        onSelected: (value) => onSelected(value),
        currentSelection: currentSelection,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: items.entries
            .map<Widget>((entry) => RadioListTile(
                  value: entry.value,
                  title: Text(entry.key),
                  groupValue: currentSelection,
                  onChanged: onSelected,
                ))
            .toList(),
      );
    }
  }

  Widget getSettingsWidgets(Widget child) {
    if (Platform.isIOS) {
      return CSWidget(child);
    }
    return ListTile(
      title: child,
    );
  }

  PageRoute getPageRoute({required WidgetBuilder builder}) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: builder);
    } else {
      return MaterialPageRoute(builder: builder);
    }
  }

  Widget getSettingsButton(
      {required String text, required VoidCallback onPress}) {
    if (Platform.isIOS) {
      return CSButton(CSButtonType.DEFAULT, text, onPress);
    } else {
      return ListTile(
        title: Text(text),
        onTap: onPress,
      );
    }
  }
}
