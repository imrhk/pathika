import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final bool useColorsOnCard;
  final Color? highlightTextColor;
  final Gradient? textGradient;
  final Paint? shadowTextPaint;
  final bool useEmojiChars;

  AppThemeExtension({
    this.useColorsOnCard = false,
    this.highlightTextColor,
    this.textGradient,
    this.shadowTextPaint,
    this.useEmojiChars = true,
  });

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    bool? useColorsOnCard,
    Color? highlightTextColor,
    Gradient? textGradient,
    Paint? shadowTextPaint,
    bool? useEmojiChars,
  }) {
    return AppThemeExtension(
      useColorsOnCard: useColorsOnCard ?? this.useColorsOnCard,
      highlightTextColor: highlightTextColor ?? this.highlightTextColor,
      textGradient: textGradient ?? this.textGradient,
      shadowTextPaint: shadowTextPaint ?? this.shadowTextPaint,
      useEmojiChars: useEmojiChars ?? this.useEmojiChars,
    );
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
      textGradient: Gradient.lerp(textGradient, other.textGradient, t),
      shadowTextPaint: other.shadowTextPaint,
      useEmojiChars: other.useEmojiChars,
    );
  }
}
