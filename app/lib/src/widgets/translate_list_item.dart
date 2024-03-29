import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TranslateListItem extends StatefulWidget {
  final Widget child;
  final double traslateHeight;
  final Duration duration;
  final Function getScrollDirection;
  final Axis axis;
  const TranslateListItem({
    super.key,
    required this.traslateHeight,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    required this.getScrollDirection,
    this.axis = Axis.vertical,
  });

  @override
  createState() => _TranslateListItemState();
}

class _TranslateListItemState extends State<TranslateListItem>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final scrollDirection = widget.getScrollDirection();
    final isScrollUp = scrollDirection == ScrollDirection.reverse;
    final isScrollDown = scrollDirection == ScrollDirection.forward;
    final isScrollIdle = scrollDirection == ScrollDirection.idle;

    double begin, end;
    if (isScrollIdle) {
      begin = 0;
      end = 0;
    } else if (isScrollDown) {
      begin = widget.traslateHeight;
      end = 0;
    } else if (isScrollUp) {
      begin = -widget.traslateHeight;
      end = 0;
    } else {
      throw Exception('Invalid scrollDirection');
    }

    _animation = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate))
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dx = widget.axis == Axis.vertical ? 0 : _animation.value;
    double dy = widget.axis == Axis.vertical ? _animation.value : 0;
    return Transform.translate(
      offset: Offset(dx, dy),
      transformHitTests: true,
      child: widget.child,
    );
  }
}
