import 'dart:ui';

import 'package:flutter/material.dart';

class FrostTransition extends AnimatedWidget {
  final Widget child;
  final Animation<double> animation;

  FrostTransition({this.animation, this.child}) : super(listenable: animation);

  @override
  Widget build(BuildContext context) => new BackdropFilter(
    filter:
    ImageFilter.blur(sigmaX: animation.value, sigmaY: animation.value),
    child: FadeTransition(
      opacity: animation,
      child: Container(
        child: child,
      ),
    ),
  );
}
