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
  int _matrixRowSize = 20;
  int _matrixColumnSize = 20;

  @override
  void initState() {
    super.initState();
    initMatrix();
  }

  void initMatrix() {
    _matrixGrid = List<List<int>>(_matrixColumnSize);
    for (var i = 0; i < _matrixColumnSize; i++) {
      List<int> row = List<int>(_matrixRowSize);
      for (var j = 0; j < _matrixRowSize; j++) {
        row[j] = 0;
      }

      _matrixGrid[i] = row;
    }
  }

  void _startStopGame() {
    if (_isRunning) {
      _loopGame?.cancel();
    } else {
      _loopGame = Timer.periodic(const Duration(seconds: 2), _runGame);
    }

    setState(() {
      _isRunning = !_isRunning;
      _counterLoop = 0;
    });
  }

  int _testCells(int x, int y) {
    var _nbCellNoEmpty = 0;
    //Test cells around
    for (var i = -1; i <= 1; i++) {
      for (var j = -1; j < 1; j++) {
        var tmpX = x + i, tmpY = y + j;
        //no test current cells and out of bound cells
        if (i == 0 && j == 0 ||
            tmpX < 0 ||
            tmpY < 0 ||
            tmpX > _matrixColumnSize ||
            tmpY > _matrixRowSize) {
          continue;
        }

        if (_matrixGrid[tmpX][tmpY] == 1) _nbCellNoEmpty++;
      }
    }

    if (_matrixGrid[x][y] == 0 && _nbCellNoEmpty == 3) {
      _matrixGrid[x][y] = 1;
    } else if (_matrixGrid[x][y] == 1 &&
        (_nbCellNoEmpty != 3 || _nbCellNoEmpty != 2)) {
      _matrixGrid[x][y] = 0;
    }
    return _matrixGrid[x][y];
  }

  void _runGame(Timer timer) {
    var tmpCouterCells = 0;
    for (var i = 0; i < _matrixColumnSize; i++) {
      for (var j = 0; j < _matrixRowSize; j++) {
        tmpCouterCells += _testCells(i, j);
      }

      setState(() {
        _counterLoop++;
        _counterCells = tmpCouterCells;
      });
    }
  }

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
      onTap: !_isRunning
          ? () {
              setState(() {
                print("click {$x,$y}");
                if (_matrixGrid[x][y] != 0) {
                  _counterCells--;
                  _matrixGrid[x][y] = 0;
                } else {
                  _counterCells++;
                  _matrixGrid[x][y] = 1;
                }
              });
            }
          : null,
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: Container(
              color: _matrixGrid[x][y] == 1 ? Colors.blue : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
