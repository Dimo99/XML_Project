import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:joke_app/utils/colors.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 80,
        ),
      ),
    );
  }
}
