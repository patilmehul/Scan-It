//old files and new scan button
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
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
        backgroundColor:Colors.blueGrey ,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
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

                return ListView.builder(
                  itemCount: previousFiles.length,
                  itemBuilder: (BuildContext ctx,int index){
                    // DateTime d=file['date'];
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border:Border.all(color: Colors.black)
                        ),
                        child: ListTile(
                          onTap: ()async{
                            try{
                              print(previousFiles[index]['fileUrl']);
                              await PdftronFlutter.openDocument(previousFiles[index]['fileUrl']);
                            }
                            catch(e){
                              Fluttertoast.showToast(msg: "An Error Occurred!");
                            }
                          },
                          tileColor: Colors.white,

                          title: Text(previousFiles[index]['title']+".pdf"),
                          // subtitle: Text("${d.day}"+" "+"${d.month}"+" "+"${d.year}"),
                          trailing: IconButton(
                            onPressed: ()async{
                              try{
                                dynamic data = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
                                List array = data['previousFiles'];
                                array.removeAt(index);
                                print(array);
                                await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(
                                    {
                                      'previousFiles': array,
                                    }
                                ).then((value) => print("Success"));
                                Fluttertoast.showToast(msg: "Successfully Deleted...");

                              }catch(e){
                                Fluttertoast.showToast(msg: "An Error occured while Deleting...");
                              }
                            },
                            icon: Icon(Icons.delete),),
                        ),
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
