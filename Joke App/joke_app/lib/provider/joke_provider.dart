import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:joke_app/model/Joke.dart';
import 'package:xml/xml.dart';

class JokeProvider extends ChangeNotifier{
  Future<String> xml;

  File file;
  XmlDocument document;

  int _id;
  Map<int, Joke> data;
  List<String> categoryData;

  bool isLoading;

  // Selector
  Iterable<XmlElement> categoryIterable;

  JokeProvider() {
    xml = rootBundle.loadString('assets/data.xml');
    _id = 0;
    data = <int, Joke> {};
    categoryData = <String>[];
    isLoading = true;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    File localFile = File('$path/data.xml');

    if (await localFile.exists()) {
      return localFile;
    } else {
      await localFile.create();
      await localFile.writeAsString(await xml);
      return localFile;
    }
  }

  void open() async {
    file = await _localFile;
    document = XmlDocument.parse(await file.readAsString());
    load();
  }

  void load() {
    try {
      XmlElement categories = document.getElement('Categories');
      categoryIterable = categories.findElements('Category');

      categoryIterable.forEach((category) {
        String categoryName = category.getElement('CategoryName').text;
        categoryData.add(categoryName);
        Iterable<XmlElement> jokesIterable = category.findAllElements('Anecdote');

        jokesIterable.forEach((joke) {
          Map<String, dynamic> jokeData = <String, dynamic>{};
          int id = int.parse(joke.getAttribute('id'));
          jokeData['id'] = id.toString();
          jokeData['categoryName'] = categoryName;
          jokeData['content'] = joke
              .getElement('Content')
              .text;
          jokeData['numberOfLikes'] = joke
              .getElement('NumberOfLikes')
              .text;
          jokeData['numberOfHearts'] = joke
              .getElement('NumberOfHearts')
              .text;
          jokeData['numberOfHaha'] = joke
              .getElement('NumberOfHaha')
              .text;
          jokeData['numberOfWow'] = joke
              .getElement('NumberOfWow')
              .text;
          jokeData['numberOfSad'] = joke
              .getElement('NumberOfSad')
              .text;
          jokeData['numberOfFacebookShares'] = joke
              .getElement('NumberOfFacebookShares')
              .text;
          data[id] = Joke.fromData(jokeData);
          ++_id;
        });
      });
    } catch (e) {
      print(e.toString());
    }

    setLoad(false);
    notifyListeners();
  }

  void updateLikeStat(int index) {
    ++data[index].numberOfLikes;

    notifyListeners();

    for (XmlElement category in categoryIterable) {
      if (category.getElement('CategoryName').text == data[index].categoryName) {
        for (XmlElement joke in category.findAllElements('Anecdote')) {
          if (joke.getAttribute('id') == index.toString()) {
            joke.getElement('NumberOfLikes').innerText = data[index].numberOfLikes.toString();
            break;
          }
        }
        break;
      }
    }

    file.writeAsString(document.toXmlString());
  }

  void updateHeartStat(int index) {
    ++data[index].numberOfHearts;

    for (XmlElement category in categoryIterable) {
      if (category.getElement('CategoryName').text == data[index].categoryName) {
        for (XmlElement joke in category.findAllElements('Anecdote')) {
          if (joke.getAttribute('id') == index.toString()) {
            joke.getElement('NumberOfHearts').innerText = data[index].numberOfHearts.toString();
            break;
          }
        }
        break;
      }
    }

    file.writeAsString(document.toXmlString());

    notifyListeners();
  }

  void updateHahaStat(int index) {
    ++data[index].numberOfHaha;

    for (XmlElement category in categoryIterable) {
      if (category.getElement('CategoryName').text == data[index].categoryName) {
        for (XmlElement joke in category.findAllElements('Anecdote')) {
          if (joke.getAttribute('id') == index.toString()) {
            joke.getElement('NumberOfHaha').innerText = data[index].numberOfHaha.toString();
            break;
          }
        }
        break;
      }
    }

    file.writeAsString(document.toXmlString());

    notifyListeners();
  }

  void updateWoWStat(int index) {
    ++data[index].numberOfWow;

    for (XmlElement category in categoryIterable) {
      if (category.getElement('CategoryName').text == data[index].categoryName) {
        for (XmlElement joke in category.findAllElements('Anecdote')) {
          if (joke.getAttribute('id') == index.toString()) {
            joke.getElement('NumberOfWow').innerText = data[index].numberOfWow.toString();
            break;
          }
        }
        break;
      }
    }

    file.writeAsString(document.toXmlString());

    notifyListeners();
  }

  void updateSadStat(int index) {
    ++data[index].numberOfSad;

    for (XmlElement category in categoryIterable) {
      if (category.getElement('CategoryName').text == data[index].categoryName) {
        for (XmlElement joke in category.findAllElements('Anecdote')) {
          if (joke.getAttribute('id') == index.toString()) {
            joke.getElement('NumberOfSad').innerText = data[index].numberOfSad.toString();
            break;
          }
        }
        break;
      }
    }

    file.writeAsString(document.toXmlString());

    notifyListeners();
  }

  Map<int, Joke> searchByCategory(int categoryIndex) {
    Map<int, Joke> storage = <int, Joke> {};

    data.forEach((key, value) {
      if (value.categoryName == categoryData[categoryIndex]) {
        storage[key] = value;
      }
    });

    return storage;
  }

  void addJoke(int categoryIndex, String content) {
    int id = _id;

    Joke joke = Joke(
      id: id,
      categoryName: categoryData[categoryIndex],
      content: content,
    );

    data[id] = joke;

    XmlBuilder builder = XmlBuilder();

    builder.element('Anecdote', nest: () {
      builder.attribute('id', id.toString());
      builder.element('Content', nest: () {
        builder.text(content);
      });
      builder.element('NumberOfLikes', nest: () {
        builder.text(joke.numberOfLikes);
      });
      builder.element('NumberOfHearts', nest: () {
        builder.text(joke.numberOfHearts);
      });
      builder.element('NumberOfHaha', nest: () {
        builder.text(joke.numberOfHaha);
      });
      builder.element('NumberOfWow', nest: () {
        builder.text(joke.numberOfWow);
      });
      builder.element('NumberOfSad', nest: () {
        builder.text(joke.numberOfSad);
      });
      builder.element('NumberOfFacebookShares', nest: () {
        builder.text(joke.numberOfFacebookShares);
      });
    });

    for (XmlElement category in categoryIterable) {
      if (category.getElement('CategoryName').text == categoryData[categoryIndex]) {
        category.children.add(builder.buildFragment());
        break;
      }
    }

    file.writeAsString(document.toXmlString());

    ++_id;

    notifyListeners();
  }

  void setLoad(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}