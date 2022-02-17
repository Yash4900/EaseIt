import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:ease_it/utility/pick_image.dart';

class ImageViewer extends StatefulWidget {
  File imageFile;

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
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              File temp = await PickImage().showPicker(context);
              if (temp != null) {
                setState(() {
                  widget.imageFile = temp;
                });
              }
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
              size: 25,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.crop_outlined,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () async {
              widget.imageFile = await ImageCropper.cropImage(
                sourcePath: widget.imageFile.path,
                androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Crop Image',
                  toolbarColor: Color(0xff1a73e8),
                  toolbarWidgetColor: Colors.white,
                  lockAspectRatio: true,
                ),
              );
              setState(() {});
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context, widget.imageFile);
            },
            icon: Icon(
              Icons.check_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(
        child: PhotoView(
          imageProvider: FileImage(widget.imageFile),
        ),
      ),
    );
  }
}
