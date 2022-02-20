import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SingleImageViewer extends StatelessWidget {
  final imageFile;
  const SingleImageViewer({Key key, @required this.imageFile})
      : super(key: key);

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
          imageProvider: FileImage(imageFile),
        ),
      ),
    );
  }
}
