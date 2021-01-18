import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:joke_app/provider/joke_provider.dart';
import 'package:joke_app/screens/add_joke_screen.dart';
import 'package:joke_app/screens/category_screen.dart';
import 'package:joke_app/shared/joke_card.dart';
import 'package:joke_app/shared/loader.dart';
import 'package:joke_app/utils/colors.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<JokeProvider>(context, listen: false).open();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JokeProvider>(
      builder: (context, provider, child) {
        return _build(context, provider);
      },
    );
  }

  Widget _build(BuildContext context, JokeProvider provider) {
    if (provider.isLoading) {
      return Loader();
    } else {
      List<int> keys = provider.data.keys.toList();
      return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: Text("Jokes App"),
          centerTitle: true,
          backgroundColor: appbar,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              tooltip: "Search",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CategoryScreen(provider),
                ));
              }
            )
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) {
            return JokeCard(joke: provider.data[keys[index]]);
          },
          itemCount: provider.data.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddJokeScreen(),
            ));
          },
          child: Icon(Icons.add),
          backgroundColor: appbar,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
  }
}
