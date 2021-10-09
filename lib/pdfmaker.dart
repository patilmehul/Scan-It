// ignore_for_file: unused_import, unnecessary_statements
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> generatePDF(String text, File image) async {
  // final document = pw.Document();
  // document.addPage(
  //   pw.Page(
  //     build: (pw.Context context) => pw.Center(
  //       child: pw.Text(text),
  //     ),
  //   ),
  // );
  FirebaseAuth _auth=FirebaseAuth.instance;
  final file = image;
  String fileName = basename(image.path);
  Reference reference =FirebaseStorage.instance.ref().child("${_auth.currentUser!.displayName! + "/" + fileName}");
  UploadTask uploadTask = reference.putFile(file);
  TaskSnapshot snapshot = await uploadTask;
  String fileUrl = await snapshot.ref.getDownloadURL();
  print(fileUrl);
  Fluttertoast.showToast(msg: "URL Received");
}
