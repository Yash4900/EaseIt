import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/alert.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  @override
  void initState() {
    imageUrl =
        g.imageUrl == '' ? 'assets/default_profile_picture.png' : g.imageUrl;
    fnameController.text = g.fname;
    lnameController.text = g.lname;
    emailController.text = g.email;
    phoneController.text = g.phoneNum;
    super.initState();
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
            bool confirmation = await showAlertDialog(context, 'Alert',
                'Are you sure you want to leave? Your changes will be discarded');
            if (confirmation) {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: isLoading
          ? Loading()
          : Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Form(
                onWillPop: () async => false,
                key: _formKey,
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
                                  _profilePicture == null
                                      ? Icons.add
                                      : Icons.edit,
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
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            controller: lnameController,
                            validator: (value) => value.length < 2
                                ? 'Enter valid last name'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      controller: emailController,
                      validator: (value) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return "Invalid Email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            style: TextStyle(color: Colors.grey[500]),
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "🇮🇳 +91",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            validator: (value) => value.length != 10
                                ? 'Enter a valid number'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Fill in the field if you wish to change your email or password',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500]),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Current Password',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      controller: oldPasswordController,
                      obscureText: true,
                      validator: (value) => value.length < 6
                          ? 'Password must have atleast 6 characters'
                          : null,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Fill in the below fields if you want to change your password',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500]),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'New Password',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) => value.length < 6
                          ? 'Password must have atleast 6 characters'
                          : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Confirm New Password',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      controller: confirmPasswordController,
                      obscureText: true,
                      validator: (value) => value != passwordController.text
                          ? 'Not matching with the password'
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {}
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff1a73e8)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                        child: Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
