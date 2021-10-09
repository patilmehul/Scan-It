import 'package:flutter/material.dart';

class ControlsWidget extends StatelessWidget {
  final VoidCallback onClickedPickImage;
  final VoidCallback onClickedScanText;
  final VoidCallback onClickedPickImageGallery;

  const ControlsWidget({
    required this.onClickedPickImage,
    required this.onClickedScanText,
    required this.onClickedPickImageGallery,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        onPressed: onClickedPickImageGallery,
        icon: Icon(Icons.photo_album,size: 40.0,color: Colors.blueGrey,),
      ),

      ElevatedButton(
        onPressed: onClickedScanText,
        child: Text('Recognize Text'),
        style:ElevatedButton.styleFrom(primary: Colors.blueGrey)
      ),

      IconButton(
        onPressed: onClickedPickImage,
        icon: Icon(Icons.camera,size: 40.0,color: Colors.blueGrey,),
      ),
    ],
  );
}