import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'model_game.dart';
import 'const_var.dart';
import 'random_picker_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
  double _randomThreshold = 0.75;
  List<double> _historicList = [0.0];

  @override
  void initState() {
    super.initState();
    _model = ModelGame(25, 25);
  }

  void _startPauseGame() {
    if (_isRunning) {
      _loopGame?.cancel();
    } else {
      _loopGame = Timer.periodic(const Duration(seconds: 2), _runGame);
    }

    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _resetGame() {
    _historicList = [0.0];
    _model.razMatrix();
    _loopGame?.cancel();
    setState(() {
      _counterLoop = 0;
      _counterCells = 0;
      _isRunning = false;
    });
  }

  void _runGame(Timer timer) {
    setState(() {
      _model.generateNextModelState();
      _counterLoop++;
      _counterCells = _model.getCellAlive();
      _historicList.add(_counterCells.roundToDouble());
    });
  }

  Future<void> _showRandomPickerDialog() async {
    final selectedFontSize = await showDialog<double>(
      context: context,
      builder: (context) =>
          RandomPickerDialog(initialRandomThreshold: _randomThreshold),
    );

    if (selectedFontSize != null) {
      _randomThreshold = selectedFontSize;
    }
  }

  void _select(CustomMenuItem selectItem) async {
    if (_isRunning) _resetGame();

    if (selectItem.list == null) {
      //aléatoire case
      await _showRandomPickerDialog();
      _model.generateRandomGrid(_randomThreshold);
    } else {
      _model.applyModel(selectItem.width, selectItem.height, selectItem.list);
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
          mainAxisSize: MainAxisSize.min,
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
                child: Sparkline(
                  fallbackHeight: 12.0,
                  data: _historicList,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: _resetGame,
          tooltip: 'Reset',
          child: Icon(Icons.replay),
        ),
        Padding(
          padding: EdgeInsets.all(3.0),
        ),
        FloatingActionButton(
          onPressed: _startPauseGame,
          tooltip: _isRunning ? 'Pause' : 'Start',
          child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
        ),
      ]),
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    final y = (index / _model.rowSize).floor();
    final x = (index % _model.columnSize);
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
