import 'package:flutter/material.dart';
import 'package:scan_it/text_ocr/widgets/ocr_widgets.dart';


class OCR extends StatefulWidget {
  final String title;
  const OCR({
    required this.title,
  });
  
  @override
  _OCRState createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 25),
          TextRecognitionWidget(),
          const SizedBox(height: 15),
        ],
      ),
    ),
  );
}