import 'dart:math';

class CustomMenuItem {
  String title;
  int width;
  int height;
  List<Point> list;

  CustomMenuItem(this.title, this.width, this.height, this.list);
}

class ConstVar {
  static var menu = [
    CustomMenuItem("Aléatoire", 0, 0, null),
    CustomMenuItem("Basic line 3", 1, 3, line3),
    CustomMenuItem("Carré 4", 2, 2, square4),
    CustomMenuItem("Carré 8", 3, 3, square8),
    CustomMenuItem("Planeur", 3, 3, theAnts),
    CustomMenuItem("LWSS", 5, 4, lwss),
    CustomMenuItem("HWSS", 7, 5, hwss),
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
    Point(0, 0),
    Point(0, 2),
    Point(2, 0),
    Point(1, 3),
    Point(2, 3),
    Point(3, 3),
    Point(4, 1),
    Point(4, 2),
    Point(4, 3),
  ];

  static var hwss = [
    Point(2, 0),
    Point(3, 0),
    Point(0, 1),
    Point(5, 1),
    Point(6, 2),
    Point(0, 3),
    Point(6, 3),
    Point(6, 4),
    Point(5, 4),
    Point(4, 4),
    Point(3, 4),
    Point(2, 4),
    Point(1, 4),
    Point(0, 4),
  ];
}
