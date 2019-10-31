import 'dart:math';

class CustomMenuItem {
  String title;
  List<Point> list;

  CustomMenuItem(this.title, this.list);
}

class ConstVar {
  static var menu = [
    CustomMenuItem("Aléatoire", null),
    CustomMenuItem("Basic line 3", line3),
    CustomMenuItem("Carré 4", square4),
    CustomMenuItem("Carré 8", square8),
    //"Vaisseau"
  ];

  static var line3 = [
    Point(12, 12),
    Point(12, 13),
    Point(12, 14),
  ];

  static var square4 = [
    Point(12, 12),
    Point(12, 13),
    Point(13, 12),
    Point(13, 13),
  ];

  static var square8 = [
    Point(12, 12),
    Point(12, 13),
    Point(12, 14),
    Point(13, 12),
    Point(13, 14),
    Point(14, 12),
    Point(14, 13),
    Point(14, 14),
  ];
}
