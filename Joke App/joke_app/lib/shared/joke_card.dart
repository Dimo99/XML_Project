import 'package:flutter/material.dart';
import 'package:joke_app/model/Joke.dart';
import 'package:joke_app/screens/joke_screen.dart';

class JokeCard extends StatelessWidget {
  final Joke joke;
  final bool isLimited;

  JokeCard({
    @required this.joke,
    this.isLimited = true,
  }) : assert(joke != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Card(
          child: ListTile(
            title: Text("Категория: ${joke.categoryName}",
                style: TextStyle(
                  fontSize: 18,
                )),
            subtitle: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: isLimited
                  ? Text(joke.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                      ))
                  : Text(joke.content,
                      style: TextStyle(
                        fontSize: 16,
                      )),
            ),
          ),
        ),
      ),
      onTap: () {
        if (isLimited) executeJokeDetailScreen(context, joke);
      },
    );
  }
}
