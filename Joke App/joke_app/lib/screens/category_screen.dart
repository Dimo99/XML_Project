import 'package:flutter/material.dart';
import 'package:joke_app/model/Joke.dart';
import 'package:joke_app/provider/joke_provider.dart';
import 'package:joke_app/screens/display_search_screen.dart';
import 'package:joke_app/utils/colors.dart';

class CategoryScreen extends StatelessWidget {

  final JokeProvider provider;

  CategoryScreen(this.provider);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("Search by Category"),
        centerTitle: true,
        backgroundColor: appbar,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(provider.categoryData[index], style: TextStyle(
                      fontSize: 20,
                    ), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            onTap: () {
              Map<int, Joke> data = provider.searchByCategory(index);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => DisplaySearchScreen(
                  "Search by ${provider.categoryData[index]}",
                  data
                ),
              ));
            },
          );
        },
        itemCount: provider.categoryData.length,
      ),
    );
  }
}
