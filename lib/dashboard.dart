//old files and new scan button
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scan_it/home.dart';
import 'package:scan_it/pdf/api/pdf_api.dart';
import 'package:scan_it/text_ocr/ocr.dart';
import 'package:scan_it/signin.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    DateTime d=file['date'];
                    return GestureDetector(
                      onTap: ()async{
                        try{
                         await canLaunch(file['fileUrl']);
                        }
                        catch(e){
                          Fluttertoast.showToast(msg: "An Error Occurred!");
                        }
                      },
                      child: ListTile(
                        tileColor: Colors.blueGrey[400],
                        title: Text(file['title']+".pdf"),
                        subtitle: Text("${d.day}"+" "+"${d.month}"+" "+"${d.year}"),
                        trailing: IconButton(
                          onPressed: ()async{
                            dynamic d = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get();
                            List l=d['previousFile'];
                            l.removeAt(index);
                            await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).update({
                              'previousFiles':l,
                            }).then((value) => Fluttertoast.showToast(msg: "Deleted Successfully!"));
                          },
                          icon: Icon(Icons.delete),),
                      ),
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
