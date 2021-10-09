import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_it/pdf/pdfmaker.dart';
import 'package:scan_it/text_ocr/api/api.dart';

import 'control_widgets.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({
    Key? key,
  }) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  String text = '';
  String pdfName="";
  File f = File('images/dummy.jpeg');
  File image = File('images/dummy.jpeg');

  bool isEmpty = true;

  Widget buildImage() => Container(
        child: !isEmpty
            ? Image.file(image)
            : Icon(Icons.photo, size: 80, color: Colors.black),
      );

  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.camera);
    Fluttertoast.showToast(msg: "Image Captured");
    setImage(File(file!.path));
  }

  Future pickImageGallery() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    Fluttertoast.showToast(msg: "Image Selected");
    setImage(File(file!.path));
  }

  Future scanText() async {
    showDialog(
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
      context: context,
    );

    final text = await FirebaseMLApi.recogniseText(image);
    Fluttertoast.showToast(msg: "Scanning Successful");
    setText(text);

    Navigator.of(context).pop();
  }

  void clear() {
    setImage(f);
    setText('');
  }

  void copyToClipboard() {
    if (text.trim() != '') {
      FlutterClipboard.copy(text);
      Fluttertoast.showToast(msg: "Copied to Clipboard");
    }
  }

  void setImage(File newImage) {
    setState(() {
      isEmpty = false;
      image = newImage;
    });
  }

  void setText(String newText) {
    setState(() {
      text = newText;
    });
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Expanded(child: buildImage()),
            const SizedBox(height: 16),
            ControlsWidget(
              onClickedPickImage: pickImage,
              onClickedScanText: scanText,
              onClickedPickImageGallery: pickImageGallery,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(border: Border.all()),
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: SelectableText(
                      text.isEmpty ? 'Scan an Image to get text' : text,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.black),
                  color: Colors.grey[200],
                  onPressed: copyToClipboard,
                ),
                IconButton(
                  icon: Icon(Icons.picture_as_pdf, color: Colors.black),
                  color: Colors.grey[200],
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          content: TextFormField(
                            onChanged: (val){
                              setState(() {
                                pdfName=val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Enter the name for pdf file"
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: ()async{
                                await generatePDF(text, pdfName, image, context);
                              }, 
                              child: Text("Convert to Pdf"))
                          ],
                        );
                      }
                    );
                  },
                ),
              ],
            )
          ],
        ),
      );
}
