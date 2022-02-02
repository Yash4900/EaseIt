import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class PickImage {
  final ImagePicker _picker = ImagePicker();

  Future<XFile> _imageFromCamera() async {
    return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 640,
        maxWidth: 480);
  }

  Future<XFile> _imageFromGallery() async {
    return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 640,
        maxWidth: 480);
  }

  Future<File> showPicker(context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () async {
                      XFile file = await _imageFromGallery();
                      Navigator.of(context).pop(File(file.path));
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () async {
                    XFile file = await _imageFromCamera();
                    Navigator.of(context).pop(File(file.path));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
