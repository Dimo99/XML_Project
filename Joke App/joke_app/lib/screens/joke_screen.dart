import 'package:flutter/material.dart';
import 'package:joke_app/model/Joke.dart';
import 'package:joke_app/provider/joke_provider.dart';
import 'package:joke_app/shared/frost_overlay.dart';
import 'package:joke_app/shared/joke_card.dart';
import 'package:joke_app/utils/colors.dart';
import 'package:demoji/demoji.dart';
import 'package:provider/provider.dart';

void executeJokeDetailScreen(BuildContext context, Joke joke) {
  Navigator.of(context).push(FrostOverlay(
    layout: JokeDetailScreen(joke: joke),
  ));
}

class JokeDetailScreen extends StatelessWidget {
  final Joke joke;

  const JokeDetailScreen({@required this.joke}) : assert(joke != null);

  @override
  Widget build(BuildContext context) {
    return Consumer<JokeProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              JokeCard(joke: joke, isLimited: false),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  JokeStatusField(
                    icon: Demoji.plus_one,
                    counts: provider.data[joke.id].numberOfLikes,
                    onPressed: () {
                      provider.updateLikeStat(joke.id);
                    },
                  ),
                  JokeStatusField(
                    icon: Demoji.heart,
                    counts: provider.data[joke.id].numberOfHearts,
                    onPressed: () {
                      provider.updateHeartStat(joke.id);
                    },
                  ),
                  JokeStatusField(
                    icon: Demoji.laughing,
                    counts: provider.data[joke.id].numberOfHaha,
                    onPressed: () {
                      provider.updateHahaStat(joke.id);
                    },
                  ),
                  JokeStatusField(
                    icon: Demoji.star_struck,
                    counts: provider.data[joke.id].numberOfWow,
                    onPressed: () {
                      provider.updateWoWStat(joke.id);
                    },
                  ),
                  JokeStatusField(
                    icon: Demoji.slightly_frowning_face,
                    counts: provider.data[joke.id].numberOfSad,
                    onPressed: () {
                      provider.updateSadStat(joke.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class JokeStatusField extends StatelessWidget {
  final String icon;
  final int counts;
  final onPressed;

  JokeStatusField({this.icon, this.counts, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(icon, style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                Text(counts.toString(), style: TextStyle(
                  fontSize: 20,
                  color: appbar,
                  fontWeight: FontWeight.w700
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
