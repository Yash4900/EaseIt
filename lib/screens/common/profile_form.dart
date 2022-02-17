import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/pick_image.dart';
import 'package:ease_it/screens/common/view_image.dart';
import 'dart:io';

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  bool isLoading = false;
  File _profilePicture;
  String temp;
  Globals g = Globals();
  String imageUrl = '';
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();

  @override
  void initState() {
    imageUrl =
        g.imageUrl == '' ? 'assets/default_profile_picture.png' : g.imageUrl;
    fnameController.text = g.fname;
    lnameController.text = g.lname;
    super.initState();
  }

  void _showAlertDialog(BuildContext context) {
    Widget yesButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    Widget noButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Alert",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Are you sure you want to leave? Your changes will be discarded",
        style: TextStyle(
          fontSize: 17,
        ),
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.1,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            _showAlertDialog(context);
          },
        ),
      ),
      body: isLoading
          ? Loading()
          : Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (imageUrl ==
                                'assets/default_profile_picture.png') {
                              _profilePicture =
                                  await PickImage().showPicker(context);
                              if (_profilePicture != null) {
                                File temp = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageViewer(
                                      imageFile: _profilePicture,
                                    ),
                                  ),
                                );
                                if (temp != null) {
                                  setState(() {
                                    _profilePicture = temp;
                                    imageUrl = _profilePicture.path;
                                  });
                                } else {
                                  setState(() {
                                    _profilePicture = null;
                                    imageUrl =
                                        'assets/default_profile_picture.png';
                                  });
                                }
                              }
                            } else {
                              File temp = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                    imageFile: _profilePicture,
                                  ),
                                ),
                              );
                              if (temp != null) {
                                setState(() {
                                  _profilePicture = temp;
                                  imageUrl = _profilePicture.path;
                                });
                              } else {
                                setState(() {
                                  _profilePicture = null;
                                  imageUrl =
                                      'assets/default_profile_picture.png';
                                });
                              }
                            }
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xfff3f3f3),
                              image: DecorationImage(
                                image: imageUrl ==
                                        'assets/default_profile_picture.png'
                                    ? AssetImage(imageUrl)
                                    : FileImage(File(imageUrl)),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -7,
                          right: -5,
                          child: GestureDetector(
                            onTap: () async {
                              _profilePicture =
                                  await PickImage().showPicker(context);
                              setState(() {});
                              if (_profilePicture != null) {
                                File temp = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageViewer(
                                      imageFile: _profilePicture,
                                    ),
                                  ),
                                );
                                if (temp != null) {
                                  setState(() {
                                    _profilePicture = temp;
                                    imageUrl = _profilePicture.path;
                                  });
                                } else {
                                  setState(() {
                                    _profilePicture = null;
                                    imageUrl =
                                        'assets/default_profile_picture.png';
                                  });
                                }
                              }
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              child: Icon(
                                imageUrl == '' ? Icons.add : Icons.edit,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff1a73e8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          controller: fnameController,
                          validator: (value) => value.length < 2
                              ? 'Enter valid first name'
                              : null,
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          controller: lnameController,
                          validator: (value) => value.length < 2
                              ? 'Enter valid first name'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
