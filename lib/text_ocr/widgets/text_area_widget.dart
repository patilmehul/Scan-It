import 'package:flutter/material.dart';
import 'package:scan_it/pdfmaker.dart';

class TextAreaWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClickedCopy;

  const TextAreaWidget({
    required this.text,
    required this.onClickedCopy,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Container(
          height: 100,
          decoration: BoxDecoration(border: Border.all()),
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: SelectableText(
            text.isEmpty ? 'Scan an Image to get text' : text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.copy, color: Colors.black),
        color: Colors.grey[200],
        onPressed: onClickedCopy,
      ),
      IconButton(
        onPressed: () async {
          await generatePDF(text);
        },
        icon: Icon(Icons.picture_as_pdf),),
    ],
  );
}