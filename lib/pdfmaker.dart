// ignore_for_file: unused_import, unnecessary_statements
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


Future<void> generatePDF(String text) async{
  final document = pw.Document();
  document.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text(text),
      ),
    ),
  );
  final file = File('example.pdf');
  await file.writeAsBytes(await document.save());
}