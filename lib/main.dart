import 'dart:async';

import 'package:flutter/material.dart';
import 'model_game.dart';
import 'const_var.dart';

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
  ModelGame _model;
  int _counterLoop = 0, _counterCells = 0;
  bool _isRunning = false;
  Timer _loopGame;

  @override
  void initState() {
    super.initState();
    _model = ModelGame(25, 25);
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
    setState(() {
      _model.generateNextModelState();
      _counterLoop++;
      _counterCells = _model.getCellAlive();
    });
  }

  void _select(CustomMenuItem selectItem) {
    if (selectItem.list == null) {
      //aléatoire case
      _model.generateRandomGrid();
    } else {
      _model.applyModel(selectItem.list);
    }
    setState(() {
      _counterCells = _model.getCellAlive();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<CustomMenuItem>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return ConstVar.menu.map((CustomMenuItem item) {
                return PopupMenuItem(
                  value: item,
                  child: Text(item.title),
                );
              }).toList();
            },
          ),
        ],
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
                    crossAxisCount: _model.rowSize,
                  ),
                  itemBuilder: _buildGridItems,
                  itemCount: _model.rowSize * _model.columnSize,
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
    final x = (index / _model.rowSize).floor();
    final y = (index % _model.columnSize);
    return GestureDetector(
      onTap: !_isRunning
          ? () {
              setState(() {
                print("click {$x,$y}");
                if (_model.getCellValue(x, y) != 0) {
                  _model.setCellValue(x, y, 0);
                } else {
                  _model.setCellValue(x, y, 1);
                }
                _counterCells = _model.getCellAlive();
              });
            }
          : null,
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: Container(
              color:
                  _model.getCellValue(x, y) == 1 ? Colors.blue : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
