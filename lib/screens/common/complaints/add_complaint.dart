import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/firebase/storage.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/pick_image.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/multiple_image_editor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

class AddComplaint extends StatefulWidget {
  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  File _profilePicture;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Globals g = Globals();
  bool loading = false;
  List<File> imageFiles = [];

  Widget returnCarouselWidget(List<File> imgList) {
    List<Widget> imageSliders = createImageSlidingWidget(imgList);
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          initialPage: 2,
          autoPlay: true,
        ),
        items: imageSliders,
      ),
    );
  }

  List<Widget> createImageSlidingWidget(List<File> imgList) {
    List<Widget> temp = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.file(item,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.9),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              'Image No. ${imgList.indexOf(item) + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    temp.add(
      Container(
        color: Colors.grey[200],
        child: GestureDetector(
          onTap: () async {
            imageFiles = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultipleImageEditor(
                  imageFiles: imageFiles,
                ),
              ),
            );
            setState(() {});
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: temp.length == 5
                    ? [
                        Icon(
                          Icons.edit,
                          color: Colors.grey[500],
                          size: 25,
                        ),
                        Text(
                          "Edit Images",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    : [
                        Icon(
                          Icons.add,
                          color: Colors.grey[500],
                          size: 25,
                        ),
                        Text(
                          "Add Images",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () async {
            bool confirmation = await showAlertDialog(context, 'Alert',
                'Are you sure you want to leave? Your changes will be discarded');
            if (confirmation) {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            }
          },
          child: Row(
            children: [
              Icon(Icons.keyboard_backspace, color: Colors.black),
              SizedBox(width: 5),
              Text(
                'Back',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: [
                  Text(
                    'Help your society improve!!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Post your complaint / suggestion below',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'IMAGE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 5),
                  imageFiles == null || imageFiles.isEmpty
                      ? Material(
                          child: InkWell(
                            child: GestureDetector(
                              onTap: () async {
                                imageFiles = await PickImage()
                                    .showMultiPicker(context, 50);
                                setState(() {});
                                if (imageFiles != null &&
                                    imageFiles.isNotEmpty) {
                                  imageFiles = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MultipleImageEditor(
                                        imageFiles: imageFiles,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                } else {
                                  setState(() {});
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Colors.grey[800],
                                    size: 50,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                              ),
                            ),
                          ),
                        )
                      : returnCarouselWidget(imageFiles),
                  Text(
                    "You can select upto 5 images",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 12.5,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     _profilePicture =
                  //         await PickImage().showPicker(context, 50);
                  //     if (_profilePicture != null) {
                  //       _profilePicture = await ImageCropper.cropImage(
                  //         sourcePath: _profilePicture.path,
                  //         aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
                  //         androidUiSettings: AndroidUiSettings(
                  //           toolbarTitle: 'Crop Image',
                  //           toolbarColor: Colors.black,
                  //           activeControlsWidgetColor: Color(0xff037DD6),
                  //           toolbarWidgetColor: Colors.white,
                  //           initAspectRatio: CropAspectRatioPreset.original,
                  //           lockAspectRatio: true,
                  //         ),
                  //       );
                  //     }
                  //     setState(() {});
                  //   },
                  //   child: Container(
                  //     child: Center(
                  //       child: Icon(
                  //         Icons.camera_alt_outlined,
                  //         color: Colors.white,
                  //         size: 30,
                  //       ),
                  //     ),
                  //     height: MediaQuery.of(context).size.height * 0.3,
                  //     decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //         fit: BoxFit.cover,
                  //         image: _profilePicture == null
                  //             ? AssetImage('assets/dummy_image.jpg')
                  //             : FileImage(_profilePicture),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 25),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TITLE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter a title'),
                          maxLines: null,
                          controller: _titleController,
                          validator: (value) =>
                              value.length == 0 ? 'Please enter a title' : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'DESCRIPTION',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter description'),
                          maxLines: null,
                          controller: _descController,
                          validator: (value) => value.length == 0
                              ? 'Please enter description'
                              : null,
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                bool confirmation = await showConfirmationDialog(
                                    context,
                                    "Alert!",
                                    "Are you sure you want to add this complaint?");
                                if (confirmation) {
                                  setState(() => loading = true);
                                  List<String> linkOfImages = [];
                                  String id = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  if (imageFiles.length != 0) {
                                    for (int i = 0;
                                        i < imageFiles.length;
                                        i++) {
                                      String newImageUrl =
                                          await Storage().storeImage(
                                        "complaints/$id",
                                        "${id}_$i",
                                        imageFiles[i],
                                      );
                                      if (newImageUrl == null) {
                                        setState(() {
                                          loading = false;
                                        });
                                        showToast(context, "error", "Error",
                                            "Unable to upload Images");
                                        return;
                                      } else {
                                        linkOfImages.add(newImageUrl);
                                      }
                                    }
                                  }
                                  // String imageUrl = _profilePicture == null
                                  //     ? ""
                                  //     : await Storage().storeImage(
                                  //         'complaints', id, _profilePicture);
                                  Database()
                                      .addComplaint(
                                          id,
                                          g.society,
                                          _titleController.text,
                                          _descController.text,
                                          linkOfImages,
                                          g.uid)
                                      .then((value) {
                                    setState(() => loading = false);
                                    showToast(context, "success", "Success!",
                                        "Complaint added successfully");
                                    Navigator.pop(context);
                                  }).catchError(() {
                                    setState(() => loading = false);
                                    showToast(context, "error", "Oops!",
                                        "Something went wrong");
                                  });
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              child: Text(
                                'Publish',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff037DD6)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
