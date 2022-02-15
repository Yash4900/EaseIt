import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImageViewer extends StatefulWidget {
  File imageFileToView;

  ImageViewer({Key key, @required File imageFileToView}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  void initState() {
    print("Inside View Image");
    print(widget.imageFileToView);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: PhotoView(
          imageProvider: FileImage(widget.imageFileToView),
        ),
      ),
    );
  }
}
