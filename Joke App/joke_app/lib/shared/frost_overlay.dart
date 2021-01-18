import 'package:joke_app/shared/frost_transition.dart';
import 'package:flutter/material.dart';

class FrostOverlay extends PopupRoute<Null> {
  static const double frostAnimationStartValue = 0.0;
  static const double frostAnimationEndValue = 10.0;

  final Widget layout;

  FrostOverlay({this.layout});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "Close";

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) =>
      FrostTransition(
        animation: Tween<double>(
          begin: frostAnimationStartValue,
          end: frostAnimationEndValue,
        ).animate(animation),
        child: child,
      );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) =>
      layout;
}
