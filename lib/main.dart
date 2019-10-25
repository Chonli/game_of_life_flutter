import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game of life',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Game of life'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counterLoop = 0;
  int _counterCells = 0;
  bool _isRunning = false;
  Timer _loopGame;
  List<List<int>> _matrixGrid;
  int _matrixRowSize = 30;
  int _matrixColumnSize = 30;

  @override
  void initState() {
    super.initState();
    initMatrix();
  }

  void initMatrix() {
    List<List<int>> matrix = List<List<int>>(_matrixColumnSize);
    for (var i = 0; i < _matrixColumnSize; i++) {
      List<int> row = List<int>(_matrixRowSize);
      for (var j = 0; j < _matrixRowSize; j++) {
        row[j] = j;
      }

      matrix[i] = row;
    }
  }

  void _startStopGame() {
    if (_isRunning) {
    } else {}

    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _runGame() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Loop Time: $_counterLoop',
                ),
                Text(
                  'Number of cell: $_counterCells',
                ),
              ],
            ),
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                margin: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0)),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _matrixRowSize,
                  ),
                  itemBuilder: _buildGridItems,
                  itemCount: _matrixRowSize * _matrixColumnSize,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startStopGame,
        tooltip: _isRunning ? 'Stop' : 'Start',
        child: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = _matrixRowSize;
    final x = (index / gridStateLength).floor();
    final y = (index % gridStateLength);
    return GestureDetector(
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: Container(
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
