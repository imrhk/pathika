import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MaterialCard extends StatelessWidget {
  const MaterialCard({
    Key key,
    this.color,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.child,
    this.semanticContainer = true,
    this.shadowColor,
  })  : assert(elevation == null || elevation >= 0.0),
        assert(borderOnForeground != null),
        super(key: key);

  final Color color;

  final double elevation;

  final ShapeBorder shape;

  final bool borderOnForeground;

  final Clip clipBehavior;

  final EdgeInsetsGeometry margin;

  final bool semanticContainer;

  final Widget child;

  final Color shadowColor;

  static const double _defaultElevation = 1.0;

  @override
  Widget build(BuildContext context) {
    final CardTheme cardTheme = CardTheme.of(context);

    return Semantics(
      container: semanticContainer,
      child: Container(
        margin: margin ?? cardTheme.margin ?? const EdgeInsets.all(4.0),
        child: Material(
          type: MaterialType.card,
          shadowColor: shadowColor,
          color: color ?? cardTheme.color ?? Theme.of(context).cardColor,
          elevation: elevation ?? cardTheme.elevation ?? _defaultElevation,
          shape: shape ??
              cardTheme.shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
          borderOnForeground: borderOnForeground,
          clipBehavior: clipBehavior ?? cardTheme.clipBehavior ?? Clip.none,
          child: Semantics(
            explicitChildNodes: !semanticContainer,
            child: child,
          ),
        ),
      ),
    );
  }
}
