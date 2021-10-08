// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scan_it/dashboard.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await _auth.signInWithCredential(credential).then((value) {
        if (value.additionalUserInfo!.isNewUser) {
          FirebaseFirestore.instance.collection('users')
              .doc(value.user!.uid)
              .set({
            'lastSignedIn': DateTime.now(),
            'movies': [],
          })
              .then((value) => print("Collection created"));
        }
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }
}

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey,
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            :
        ElevatedButton(
          child: Text("SignIn with Google"),
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            Authentication _authentication = Authentication();
            try {
              await _authentication
                  .signInwithGoogle()
                  .whenComplete(() {
                Fluttertoast.showToast(msg: "Signed In!");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => Dashboard()));
              });
            } catch (e) {
              if (e is FirebaseAuthException) {
                Fluttertoast.showToast(
                    msg: "Error occurred while signing in...!");
              }
            }
          },
        ));


  }
}