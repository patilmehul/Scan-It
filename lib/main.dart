import 'package:flutter/material.dart';
import 'package:scan_it/root.dart';
void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: Root(),
    debugShowCheckedModeBanner: false,
  ));
}