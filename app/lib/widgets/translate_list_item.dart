
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TranslateListItem extends StatefulWidget {
  final Widget child;
  final double traslateHeight;
  final Duration duration;
  final Function getScrollDirection;
  final Axis axis;
  const TranslateListItem(
      {Key key,
      @required this.traslateHeight,
      @required this.child,
      this.duration = const Duration(milliseconds: 500),
      @required this.getScrollDirection,
      this.axis = Axis.vertical})
      : super(key: key);

  @override
  createState() => _TranslateListItemState();
}

class _TranslateListItemState extends State<TranslateListItem>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
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

    animation = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: animationController, curve: Curves.decelerate))
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dx = widget.axis == Axis.vertical ? 0 : animation.value;
    double dy = widget.axis == Axis.vertical ? animation.value : 0;
    return Transform.translate(
      offset: Offset(dx, dy),
      transformHitTests: true,
      child: widget.child,
    );
  }
}
