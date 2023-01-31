import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OptionalShimmer extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;

  const OptionalShimmer({super.key, this.gradient, required this.child});

  @override
  Widget build(BuildContext context) {
    final gradient = this.gradient;
    if (gradient == null) return child;
    final textDirection = Directionality.of(context);
    final shimmerDirection = textDirection == TextDirection.ltr
        ? ShimmerDirection.ltr
        : ShimmerDirection.rtl;
    return Shimmer(
      gradient: gradient,
      direction: shimmerDirection,
      child: child,
    );
  }
}
