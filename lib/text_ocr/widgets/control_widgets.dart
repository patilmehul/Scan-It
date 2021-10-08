import 'package:flutter/material.dart';

class ControlsWidget extends StatelessWidget {
  final VoidCallback onClickedPickImage;
  final VoidCallback onClickedScanText;
  final VoidCallback onClickedClear;

  const ControlsWidget({
    required this.onClickedPickImage,
    required this.onClickedScanText,
    required this.onClickedClear,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      RaisedButton(
        onPressed: onClickedPickImage,
        child: Text('Scan a document'),
      ),
      const SizedBox(width: 12),
      RaisedButton(
        onPressed: onClickedScanText,
        child: Text('Recognize Text'),
      ),
      const SizedBox(width: 12),
    ],
  );
}