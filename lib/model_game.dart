import 'dart:math';

class ModelGame {
  final int columnSize;
  final int rowSize;
  List<int> _matrixGrid;

  ModelGame(this.columnSize, this.rowSize) {
    razMatrix();
  }

  void razMatrix() {
    _matrixGrid = List.generate(columnSize * rowSize, (_) => 0);
  }

  void applyModel(int w, int h, List<Point> list) {
    razMatrix();
    //calcul center grid
    int centerX = ((rowSize - w) / 2).round();
    int centerY = ((columnSize - h) / 2).round();
    print(centerX);
    list.forEach(
        (p) => _matrixGrid[p.x + centerX + (rowSize * (centerY + p.y))] = 1);
  }

  void generateRandomGrid(double threshold) {
    _matrixGrid = List.generate(columnSize * rowSize,
        (_) => (Random().nextDouble() > threshold) ? 1 : 0);
  }

  int getCellAlive() {
    return _matrixGrid.fold(0, (a, b) => a + b);
  }

  int getCellValue(int x, int y) {
    if (x < 0 || y < 0 || x >= columnSize || y >= rowSize)
      return -1;
    else
      return _matrixGrid[x + rowSize * y];
  }

  bool setCellValue(int x, int y, int value) {
    if (x < 0 || y < 0 || x >= columnSize || y >= rowSize) {
      return false;
    } else {
      _matrixGrid[x + rowSize * y] = value;
      return true;
    }
  }

  void generateNextModelState() {
    final tmpmatrixGrid = List.generate(columnSize * rowSize, (_) => 0);
    for (var x = 0; x < columnSize; x++) {
      for (var y = 0; y < rowSize; y++) {
        var nbCellNoEmpty = 0;
        //Test cells around
        for (var i = -1; i <= 1; i++) {
          for (var j = -1; j <= 1; j++) {
            var tmpX = x + i, tmpY = y + j;
            //no test current cells and out of bound cells
            if ((i == 0 && j == 0) ||
                tmpX < 0 ||
                tmpY < 0 ||
                tmpX >= columnSize ||
                tmpY >= rowSize) {
              continue;
            }

            if (_matrixGrid[tmpX + rowSize * tmpY] == 1) {
              nbCellNoEmpty++;
            }
          }
        }

        if (_matrixGrid[x + rowSize * y] == 0 && nbCellNoEmpty == 3) {
          tmpmatrixGrid[x + rowSize * y] = 1;
        } else if (_matrixGrid[x + rowSize * y] == 1 &&
            (nbCellNoEmpty > 3 || nbCellNoEmpty < 2)) {
          tmpmatrixGrid[x + rowSize * y] = 0;
        } else {
          tmpmatrixGrid[x + rowSize * y] = _matrixGrid[x + rowSize * y];
        }
      }
    }
    _matrixGrid = tmpmatrixGrid;
  }
}
