import 'dart:math' as math;
import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  final List<int> entries;
  final leftOffset = 25.0;
  final topOffset = 10.0;

  ChartPainter(this.entries);

  @override
  void paint(Canvas canvas, Size size) {
    final double drawingWidth = size.width - leftOffset;
    final double drawingHeight = size.height - topOffset;

    _drawAxisLine(canvas, drawingWidth, drawingHeight);
    _drawLabels(
      canvas,
      drawingWidth,
      drawingHeight,
    );
    _drawLinesAndPoints(canvas, drawingWidth, drawingHeight);
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) {
    return entries.length != oldDelegate.entries.length;
  }

  void _drawLabels(
    Canvas canvas,
    double drawingWidth,
    double drawingHeight,
  ) {
    //max value
    final maxValue = entries.isNotEmpty ? entries.reduce(math.max) : 100;
    _drawYAxisLabel(canvas, maxValue.toString(), Offset(0, topOffset));
    //min value
    final minValue = entries.length > 1 ? entries.reduce(math.min) : 0;
    final double relativeYPosition = minValue / maxValue;
    final double yOffset =
        drawingHeight - relativeYPosition * (drawingHeight - topOffset);
    _drawYAxisLabel(canvas, minValue.toString(), Offset(0, yOffset));

    //5 on X axis
    final numberOfXLabel = 5;
    final offsetByEntry =
        entries.isNotEmpty ? (entries.length / numberOfXLabel) : 2;
    final offsetXByLabel = (drawingWidth - leftOffset) / numberOfXLabel;
    for (int i = 0; i <= numberOfXLabel; i++) {
      final displayValue = (offsetByEntry * i).round();
      final xOffset = leftOffset + i * offsetXByLabel;
      _drawYAxisLabel(
          canvas, displayValue.toString(), Offset(xOffset, drawingHeight));
    }
  }

  void _drawYAxisLabel(Canvas canvas, String text, Offset offset) {
    final textStyle = TextStyle(
      color: Colors.grey,
      fontSize: 10,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: leftOffset,
    );
    textPainter.paint(canvas, offset);
  }

  void _drawAxisLine(
    Canvas canvas,
    double drawingWidth,
    double drawingHeight,
  ) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey;

    canvas.drawLine(
      Offset(leftOffset, drawingHeight),
      Offset(drawingWidth, drawingHeight),
      paint,
    );

    canvas.drawLine(
      Offset(leftOffset, drawingHeight),
      Offset(leftOffset, topOffset),
      paint,
    );
  }

  /// Draw entry points and lines
  void _drawLinesAndPoints(
      Canvas canvas, double drawingWidth, double drawingHeight) {
    final pointSize = 2.0;
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0;

    Offset startOffset;
    Offset endOffset;
    int i;
    if (entries.length > 1) {
      for (i = 0; i < entries.length - 1; i++) {
        startOffset = _getOffset(entries[i], i, drawingWidth, drawingHeight);
        endOffset =
            _getOffset(entries[i + 1], i + 1, drawingWidth, drawingHeight);
        canvas.drawLine(startOffset, endOffset, paint);

        canvas.drawOval(
            Rect.fromPoints(
              startOffset.translate(-pointSize, pointSize),
              startOffset.translate(pointSize, -pointSize),
            ),
            paint);
      }
      //last point
      canvas.drawOval(
          Rect.fromPoints(
            endOffset.translate(-pointSize, pointSize),
            endOffset.translate(pointSize, -pointSize),
          ),
          paint);
    } else if (entries.length == 1) {
      startOffset = _getOffset(entries[0], 0, drawingWidth, drawingHeight);
      canvas.drawOval(
          Rect.fromPoints(
            startOffset.translate(-pointSize, pointSize),
            startOffset.translate(pointSize, -pointSize),
          ),
          paint);
    }
  }

  Offset _getOffset(
    int entry,
    int index,
    double drawingWidth,
    double drawingHeight,
  ) {
    final int maxValue = entries.reduce(math.max);
    final double relativeXPosition = index / entries.length;
    final double xOffset =
        leftOffset + relativeXPosition * (drawingWidth - leftOffset);
    final double relativeYPosition = entry / maxValue;
    final double yOffset =
        drawingHeight - relativeYPosition * (drawingHeight - topOffset);
    return Offset(xOffset, yOffset);
  }
}
