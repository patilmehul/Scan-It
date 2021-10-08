import 'package:flutter/material.dart';
import 'package:scan_it/root.dart';
import 'package:firebase_core/firebase_core.dart';
void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MaterialApp(
    home:Root(),
    debugShowCheckedModeBanner: false,
  ));
}