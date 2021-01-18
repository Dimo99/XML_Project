import 'package:flutter/material.dart';
import 'package:joke_app/model/Joke.dart';
import 'package:joke_app/shared/joke_card.dart';
import 'package:joke_app/utils/colors.dart';

class DisplaySearchScreen extends StatelessWidget {
  final String title;
  final Map<int, Joke> data;

  DisplaySearchScreen(this.title, this.data);

  @override
  Widget build(BuildContext context) {
    List<int> keys = data.keys.toList();
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: appbar,
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: 80),
        itemBuilder: (context, index) {
          return JokeCard(joke: data[keys[index]]);
        },
        itemCount: data.length,
      ),
    );
  }
}
