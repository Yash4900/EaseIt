import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ease_it/utility/pick_image.dart';
import 'dart:io';

class MultipleImageEditor extends StatefulWidget {
  List<File> imageFiles;
  MultipleImageEditor({Key key, @required this.imageFiles}) : super(key: key);

  @override
  State<MultipleImageEditor> createState() => _MultipleImageEditorState();
}

class _MultipleImageEditorState extends State<MultipleImageEditor> {
  List<Widget> listOfPhotoView = [];
  List<Tab> listOfTabs = [];

  @override
  void initState() {
    super.initState();
  }

  void createListOfTabs(List<File> imageFiles) {
    listOfTabs = [];
    for (File file in imageFiles) {
      listOfTabs.add(
        Tab(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: 70,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(file),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void createListOfPhotoView(List<File> imageFiles) {
    listOfPhotoView = [];
    for (File file in imageFiles) {
      listOfPhotoView.add(
        Container(
          padding: EdgeInsets.all(3),
          child: PhotoView(
            imageProvider: FileImage(file),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    createListOfTabs(widget.imageFiles);
    createListOfPhotoView(widget.imageFiles);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context, widget.imageFiles);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {},
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
            onPressed: () async {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: DefaultTabController(
            length: widget.imageFiles.length,
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: TabBarView(children: listOfPhotoView),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //color: Colors.redAccent,
                      border: Border.all(width: 2, color: Color(0xff1a73e8)),
                    ),
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    isScrollable: true,
                    tabs: listOfTabs,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
