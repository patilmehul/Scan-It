// ignore_for_file: unused_import, unnecessary_statements
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scan_it/pdf/api/pdf_api.dart';

Future<void> generatePDF(String text, File image) async {
  
  FirebaseAuth _auth=FirebaseAuth.instance;
  
  final pdf = await PdfApi.generateCenteredText(text);
   
  String fileName = basename(pdf.path);
  Reference reference =FirebaseStorage.instance.ref().child("${_auth.currentUser!.displayName! + "/" + fileName}");
  UploadTask uploadTask = reference.putFile(pdf);
  TaskSnapshot snapshot = await uploadTask;
  String fileUrl = await snapshot.ref.getDownloadURL();
  print(fileUrl);
  Fluttertoast.showToast(msg: "URL Received");
}
