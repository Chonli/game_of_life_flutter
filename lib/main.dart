import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game of life',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Game of life'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
  int _matrixRowSize = 25;
  int _matrixColumnSize = 25;

  @override
  void initState() {
    super.initState();
    initMatrix();
  }

  void initMatrix() {
    _matrixGrid = List.generate(
        _matrixColumnSize, (_) => List.generate(_matrixRowSize, (_) => 0));
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

  void _runGame(Timer timer) {
    final tmpmatrixGrid = List.generate(
        _matrixColumnSize, (_) => List.generate(_matrixRowSize, (_) => 0));
    var tmpCouterCells = 0;
    for (var x = 0; x < _matrixColumnSize; x++) {
      for (var y = 0; y < _matrixRowSize; y++) {
        var nbCellNoEmpty = 0;
        //Test cells around
        for (var i = -1; i <= 1; i++) {
          for (var j = -1; j <= 1; j++) {
            var tmpX = x + i, tmpY = y + j;
            //no test current cells and out of bound cells
            if ((i == 0 && j == 0) ||
                tmpX < 0 ||
                tmpY < 0 ||
                tmpX >= _matrixColumnSize ||
                tmpY >= _matrixRowSize) {
              continue;
            }

            if (_matrixGrid[tmpX][tmpY] == 1) {
              nbCellNoEmpty++;
            }
          }
        }

        if (_matrixGrid[x][y] == 0 && nbCellNoEmpty == 3) {
          tmpmatrixGrid[x][y] = 1;
          tmpCouterCells++;
        } else if (_matrixGrid[x][y] == 1 &&
            (nbCellNoEmpty > 3 || nbCellNoEmpty < 2)) {
          tmpmatrixGrid[x][y] = 0;
        } else {
          tmpmatrixGrid[x][y] = _matrixGrid[x][y];
          if (_matrixGrid[x][y] == 1) {
            tmpCouterCells++;
          }
        }

        print(
            "[$x,$y] ${_matrixGrid[x][y]} ==[$nbCellNoEmpty]=> ${tmpmatrixGrid[x][y]}");
      }
    }
    setState(() {
      _counterLoop++;
      _counterCells = tmpCouterCells;
      _matrixGrid = tmpmatrixGrid;
    });
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
    final x = (index / _matrixRowSize).floor();
    final y = (index % _matrixColumnSize);
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
