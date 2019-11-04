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
    _matrixGrid.asMap().forEach((index, cellValue) {
      var nbCellNoEmpty = 0;
      final y = (index / rowSize).floor();
      final x = (index % columnSize);
      final xm1 = x - 1 < 0 ? rowSize - 1 : x - 1;
      final xp1 = x + 1 >= rowSize ? 0 : x + 1;
      final ym1 = y - 1 < 0 ? columnSize - 1 : y - 1;
      final yp1 = y + 1 >= columnSize ? 0 : y + 1;

      [
        Point(xm1, ym1),
        Point(xm1, y),
        Point(xm1, yp1),
        Point(x, ym1),
        Point(x, yp1),
        Point(xp1, ym1),
        Point(xp1, y),
        Point(xp1, yp1),
      ].forEach((cell) {
        if (_matrixGrid[cell.x + rowSize * cell.y] == 1) nbCellNoEmpty++;
      });

      if (cellValue == 0 && nbCellNoEmpty == 3) {
        tmpmatrixGrid[index] = 1;
      } else if (cellValue == 1 && (nbCellNoEmpty > 3 || nbCellNoEmpty < 2)) {
        tmpmatrixGrid[index] = 0;
      } else {
        tmpmatrixGrid[index] = cellValue;
      }
    });
    _matrixGrid = tmpmatrixGrid;
  }
}
