// ignore_for_file: unused_import, unnecessary_statements
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scan_it/dashboard.dart';
import 'package:scan_it/pdf/api/pdf_api.dart';

Future<void> generatePDF(String text, String pdfName,File image,BuildContext ctx) async {
  try{
    print(pdfName);
    FirebaseAuth _auth=FirebaseAuth.instance;
    // CollectionReference users=FirebaseFirestore.instance.collection('users');
    final pdf = await PdfApi.generateCenteredText(text,pdfName);
   
    String fileName = basename(pdf.path);
    Reference reference =FirebaseStorage.instance.ref().child("${_auth.currentUser!.displayName! + "/" + fileName}");
    UploadTask uploadTask = reference.putFile(pdf);
    TaskSnapshot snapshot = await uploadTask;
    String fileUrl = await snapshot.ref.getDownloadURL();

    dynamic d = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get();

    List l=d['previousFiles'];
    print(l);
    l.add({
      'title':pdfName,
      'fileUrl':fileUrl,
      'date':DateTime.now(),
    });
    print(l);
    await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).update(
      {
        'previousFiles':l,
      }
    ).then((value){
      Fluttertoast.showToast(msg: pdfName+".pdf saved successfully");
      Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (ctx)=>Dashboard()));
    });
  }
  catch(e){
    Fluttertoast.showToast(msg: "An Error Occurred!");
  }
}