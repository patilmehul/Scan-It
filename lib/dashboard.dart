//old files and new scan button
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scan_it/home.dart';
import 'package:scan_it/text_ocr/ocr.dart';
import 'package:scan_it/signin.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Authentication _authentication = Authentication();
  CollectionReference users=FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_auth.currentUser!.displayName!}'s Scans"),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(_auth.currentUser!.photoURL!),
            child: GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        content: Text("Are you sure you want to Logout?"),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                              },
                              child: Text("NO")),
                          ElevatedButton(
                              onPressed: () async {
                                await _authentication
                                    .signOutFromGoogle()
                                    .then((value) {
                                  Fluttertoast.showToast(msg: "Signing out...");
                                  Navigator.pop(ctx);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => Home()));
                                });
                              },
                              child: Text("YES")),
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Fluttertoast.showToast(msg: "Loading Scanner...");
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=> OCR(title: "Scan a document")));
        },
        child: Icon(Icons.camera),
      ),
      body: StreamBuilder(
        stream: users.doc(_auth.currentUser!.uid).snapshots(),
        builder: (context,snapshots){
          if(!snapshots.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            try{
              dynamic d=snapshots.data;
              List previousFiles=d['previousFiles'];
              if(previousFiles.isEmpty){
                return Center(
                  child: Text("You haven't scanned any docs yet :)"),
                );
              }
              else{
                Map file={};
                return ListView.builder(
                  itemCount: previousFiles.length,
                  itemBuilder: (BuildContext ctx,int index){
                    file=previousFiles[index];
                    return ListTile(
                      title: Text(file['title']),
                    );
                  }
                );
              }
            }
            catch(e){
              return Center(
                child: Text("Oops!\nAn Error occurred :("),
              );
            }
          }
        },
      ),
    );
  }
}
