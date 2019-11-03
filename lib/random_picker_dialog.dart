import 'package:flutter/material.dart';

class RandomPickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final double initialRandomThreshold;

  const RandomPickerDialog({Key key, this.initialRandomThreshold})
      : super(key: key);

  @override
  _RandomPickerDialogState createState() => _RandomPickerDialogState();
}

class _RandomPickerDialogState extends State<RandomPickerDialog> {
  /// current selection of the slider
  double _randomThreshold;

  @override
  void initState() {
    super.initState();
    _randomThreshold = widget.initialRandomThreshold;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Seuil aléatoire'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Slider(
            value: _randomThreshold,
            min: 0.2,
            max: 0.95,
            onChanged: (value) {
              setState(() {
                _randomThreshold = value;
              });
            },
          ),
          Text(_randomThreshold.toStringAsFixed(3)),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context, _randomThreshold);
          },
          child: Text('OK'),
        )
      ],
    );
  }
}
