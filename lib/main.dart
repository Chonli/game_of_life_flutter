import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:path_provider/path_provider.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ModelGame _model;
  int _counterLoop = 0, _counterCells = 0;
  bool _isRunning = false;
  Timer _loopGame;
  double _randomThreshold = 0.75;
  List<double> _historicList = [0.0];

  @override
  void initState() {
    super.initState();
    _model = ModelGame(30, 30);
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

  void _saveInFile(BuildContext context) async {
    if (_isRunning) _startPauseGame();

    final directory = await getExternalStorageDirectory();
    _model.writeInFile(
        '${directory.path}/savGOF_${_counterCells}_$_counterLoop.txt');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
          "Donnée sauver dans '${directory.path}/savGOF_${_counterCells}_$_counterLoop.txt'"),
    ));
  }

  void _select(CustomMenuItem selectItem) async {
    if (_isRunning) _resetGame();

    _model.applyModel(selectItem.width, selectItem.height, selectItem.list);

    setState(() {
      _counterCells = _model.getCellAlive();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
      ),
      drawer: _buildDrawer(context),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 18),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              GestureDetector(
                child: ListTile(
                  title: Text("Sauver dans un fichier..."),
                ),
                onTap: () {
                  _saveInFile(context);
                  Navigator.of(context).pop();
                },
              ),
              GestureDetector(
                child: ListTile(
                  title: Text("Aléatoire"),
                ),
                onTap: () async {
                  if (_isRunning) _resetGame();

                  await _showRandomPickerDialog();
                  _model.generateRandomGrid(_randomThreshold);
                  Navigator.of(context).pop();
                  setState(() {
                    _counterCells = _model.getCellAlive();
                  });
                },
              ),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: ConstVar.menu.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: ListTile(
                      title: Text(ConstVar.menu[index].title),
                      onTap: () {
                        Navigator.of(context).pop();
                        _select(ConstVar.menu[index]);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
