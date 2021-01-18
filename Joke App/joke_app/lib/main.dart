import 'package:flutter/material.dart';
import 'package:joke_app/provider/joke_provider.dart';
import 'package:joke_app/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<JokeProvider>(
      create: (context) => JokeProvider(),
      child: MaterialApp(
        title: 'Jokes App',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}
