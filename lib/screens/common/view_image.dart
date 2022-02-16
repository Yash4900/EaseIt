import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ImageViewer extends StatefulWidget {
  final File imageFile;

  ImageViewer({Key key, @required this.imageFile}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
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
          imageProvider: FileImage(widget.imageFile),
        ),
      ),
    );
  }
}
