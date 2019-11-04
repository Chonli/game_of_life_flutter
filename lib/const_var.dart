import 'dart:math';

class CustomMenuItem {
  String title;
  int width;
  int height;
  List<Point> list;

  CustomMenuItem(this.title, this.width, this.height, this.list);
}

abstract class ConstVar {
  static var menu = [
    CustomMenuItem("Basic line 3", 1, 3, line3),
    CustomMenuItem("Carré 4", 2, 2, square4),
    CustomMenuItem("Carré 8", 3, 3, square8),
    CustomMenuItem("Planeur", 3, 3, theAnts),
    CustomMenuItem("LWSS", 5, 4, lwss),
    CustomMenuItem("HWSS", 7, 5, hwss),
    CustomMenuItem("Galaxy de Kok", 9, 9, kok),
  ];

  static var line3 = [
    Point(0, 0),
    Point(0, 1),
    Point(0, 2),
  ];

  static var square4 = [
    Point(0, 0),
    Point(0, 1),
    Point(1, 0),
    Point(1, 1),
  ];

  static var square8 = [
    Point(0, 0),
    Point(0, 1),
    Point(0, 2),
    Point(1, 0),
    Point(1, 2),
    Point(2, 0),
    Point(2, 1),
    Point(2, 2),
  ];

  static var theAnts = [
    Point(1, 0),
    Point(2, 1),
    Point(2, 2),
    Point(1, 2),
    Point(0, 2),
  ];

  static var lwss = [
    Point(1, 0),
    Point(4, 0),
    Point(0, 1),
    Point(0, 2),
    Point(4, 2),
    Point(0, 3),
    Point(1, 3),
    Point(2, 3),
    Point(3, 3),
  ];

  static var hwss = [
    Point(3, 0),
    Point(4, 0),
    Point(1, 1),
    Point(6, 1),
    Point(0, 2),
    Point(0, 3),
    Point(6, 3),
    Point(5, 4),
    Point(4, 4),
    Point(3, 4),
    Point(2, 4),
    Point(1, 4),
    Point(0, 4),
  ];

  static var kok = [
    Point(0, 0),
    Point(1, 0),
    Point(3, 0),
    Point(4, 0),
    Point(5, 0),
    Point(6, 0),
    Point(7, 0),
    Point(8, 0),
    Point(0, 1),
    Point(1, 1),
    Point(3, 1),
    Point(4, 1),
    Point(5, 1),
    Point(6, 1),
    Point(7, 1),
    Point(8, 1),
    Point(0, 2),
    Point(1, 2),
    Point(0, 3),
    Point(1, 3),
    Point(7, 3),
    Point(8, 3),
    Point(0, 4),
    Point(1, 4),
    Point(7, 4),
    Point(8, 4),
    Point(0, 5),
    Point(1, 5),
    Point(7, 5),
    Point(8, 5),
    Point(7, 6),
    Point(8, 6),
    Point(0, 7),
    Point(1, 7),
    Point(2, 7),
    Point(3, 7),
    Point(4, 7),
    Point(5, 7),
    Point(7, 7),
    Point(8, 7),
    Point(0, 8),
    Point(1, 8),
    Point(2, 8),
    Point(3, 8),
    Point(4, 8),
    Point(5, 8),
    Point(7, 8),
    Point(8, 8),
  ];
}
