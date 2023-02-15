import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final bool useColorsOnCard;
  final Color? highlightTextColor;
  final Gradient? textGradient;

  AppThemeExtension({
    this.useColorsOnCard = false,
    this.highlightTextColor,
    this.textGradient,
  });

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    bool? useColorsOnCard,
    Color? highlightTextColor,
    Gradient? textGradient,
  }) {
    return AppThemeExtension(
        useColorsOnCard: useColorsOnCard ?? this.useColorsOnCard,
        highlightTextColor: highlightTextColor ?? this.highlightTextColor,
        textGradient: textGradient ?? this.textGradient);
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
      covariant ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
        useColorsOnCard: other.useColorsOnCard,
        highlightTextColor:
            Color.lerp(highlightTextColor, other.highlightTextColor, t),
        textGradient: Gradient.lerp(textGradient, other.textGradient, t));
  }
}
