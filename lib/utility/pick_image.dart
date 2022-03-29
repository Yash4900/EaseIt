import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class PickImage {
  final ImagePicker _picker = ImagePicker();

  Future<XFile> _imageFromCamera(int quality) async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: quality,
      // maxHeight: 640,
      // maxWidth: 480,
    );
  }

  Future<XFile> _imageFromGallery(int quality) async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: quality,
      // maxHeight: 640,
      // maxWidth: 480,
    );
  }

  Future<List<XFile>> _multipleImageFromGallery(int quality) async {
    return await _picker.pickMultiImage(
      imageQuality: quality,
    );
  }

  Future<File> showPicker(context, int quality) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library, color: Colors.black87),
                    title: Text(
                      'Photo Library',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    onTap: () async {
                      XFile file = await _imageFromGallery(quality);
                      Navigator.of(context).pop(File(file.path));
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera, color: Colors.black87),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  onTap: () async {
                    XFile file = await _imageFromCamera(quality);
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

  Future<List<File>> showMultiPicker(context, int quality) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.black87),
                  title: Text(
                    'Photo Library',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  onTap: () async {
                    List<File> filesToSend = [];
                    List<XFile> files =
                        await _multipleImageFromGallery(quality);
                    if (files != null && files.isNotEmpty) {
                      for (XFile file in files) {
                        filesToSend.add(File(file.path));
                      }
                    } else {}
                    Navigator.of(context).pop(filesToSend);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera, color: Colors.black87),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  onTap: () async {
                    XFile file = await _imageFromCamera(quality);
                    if (file != null)
                      Navigator.of(context).pop([File(file.path)]);
                    else
                      Navigator.of(context).pop([]);
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
