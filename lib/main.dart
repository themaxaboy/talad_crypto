import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

final _primaryAppTextColor = const Color.fromRGBO(45, 75, 98, 1.0);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Talad Crypto App',
      theme: new ThemeData(
        fontFamily: 'TitilliumWeb',
        //brightness: Brightness.dark,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        primaryIconTheme: Theme.of(context)
            .primaryIconTheme
            .copyWith(color: _primaryAppTextColor),
        primaryTextTheme: Theme.of(context)
            .primaryTextTheme
            .apply(bodyColor: _primaryAppTextColor),
      ),
      home: new MyHomePage(title: 'Talad Crypto'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "ALL"),
                Tab(text: "THB"),
                Tab(text: "BTC"),
                Tab(text: "TOKENS"),
              ],
              labelStyle: TextStyle(fontWeight: FontWeight.w700),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: _primaryAppTextColor, width: 3.0),
              ),
            ),
            title: new Text(widget.title),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              TabBarView(
                children: [
                  RandomWords(),
                  Icon(Icons.directions_transit),
                  Icon(Icons.directions_bike),
                  Icon(Icons.directions_boat),
                ],
              ),
              Positioned(
                bottom: 150.0,
                child: Text("*"),
              ),
            ],
          )),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _biggerFont =
      const TextStyle(color: Color.fromRGBO(45, 75, 98, 1.0), fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSuggestions(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

Future<Ticker> fetchTicker() async {
  final response = await http.get('https://bx.in.th/api/');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Ticker.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load Ticker');
  }
}

class Ticker {
  final double lastPrice;
  final double change;

  Ticker({this.lastPrice, this.change});

  factory Ticker.fromJson(Map<String, dynamic> json) {
    return Ticker(lastPrice: json['last_price'], change: json['change']);
  }
}
