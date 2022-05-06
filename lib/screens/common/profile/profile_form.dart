import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/image/single_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/utility/image/pick_image.dart';
import 'package:ease_it/firebase/storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ease_it/utility/image/single_image_editor.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:io';

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  bool isLoading = false;
  File _profilePicture;
  File _defaultProfilePicture;
  //String temp;
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

  void createFileFromNetworkImage(String imageUrl) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(g.imageUrl));
    final tempDocumentDirectory = await getTemporaryDirectory();
    _profilePicture =
        File(join(tempDocumentDirectory.path, 'profile_picture.png'));
    _profilePicture.writeAsBytes(response.bodyBytes);
    setState(() {
      isLoading = false;
    });
  }

  void createFileFromAssetImage() async {
    setState(() {
      isLoading = true;
    });
    final byteData = await rootBundle.load('assets/profile_dummy.png');

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/profile_dummy.png");
    _defaultProfilePicture = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    imageUrl = g.imageUrl == '' ? 'assets/profile_dummy.png' : g.imageUrl;
    fnameController.text = g.fname;
    lnameController.text = g.lname;
    emailController.text = g.email;
    phoneController.text = g.phoneNum;
    if (g.imageUrl != "") {
      createFileFromNetworkImage(g.imageUrl);
    }
    createFileFromAssetImage();
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
                            onTap: () {
                              if (_profilePicture != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleImageViewer(
                                        imageFile: _profilePicture),
                                  ),
                                );
                              } else {
                                showToast(context, "general", "Info",
                                    "Please upload a profile photo first to view");
                              }
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xfff3f3f3),
                                image: DecorationImage(
                                  image: _profilePicture == null
                                      ? FileImage(
                                          File(_defaultProfilePicture.path))
                                      : FileImage(File(_profilePicture.path)),
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
                                if (_profilePicture == null) {
                                  _profilePicture =
                                      await PickImage().showPicker(context, 50);
                                  setState(() {});
                                  if (_profilePicture != null) {
                                    _profilePicture = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingleImageEditor(
                                            imageFile: _profilePicture),
                                      ),
                                    );
                                    setState(() {});
                                  }
                                } else {
                                  _profilePicture = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleImageEditor(
                                          imageFile: _profilePicture),
                                    ),
                                  );
                                  setState(() {});
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
                      enabled: false,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value != g.email) {
                          if (oldPasswordController.text.length < 6) {
                            return "Current Password Invalid";
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            return "Invalid Email";
                          }
                          return null;
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
                      'Fill in the below current password field field if you wish to change your password',
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
                        validator: (value) {
                          if (value.length == 0)
                            return null;
                          else if (value.length < 6)
                            return "Password must contain atleast 6 characters";
                          else
                            return null;
                        }),
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
                        validator: (value) {
                          if (value.length != 0) {
                            if (oldPasswordController.text.length < 6)
                              return "Enter valid current Password";
                            else {
                              if (value.length < 6) {
                                return "Enter a valid new password";
                              } else {
                                if (value == oldPasswordController.text) {
                                  return "Both new and old password are same change the new password";
                                }
                                return null;
                              }
                            }
                          }
                          return null;
                        }),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Confirm New Password',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      controller: confirmPasswordController,
                      obscureText: true,
                      validator: (value) => value != passwordController.text
                          ? 'Not matching with the new password'
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => isLoading = true);
                          bool saveStatus = true;
                          String message = "", newImageUrl = "";
                          bool emailChanged = false,
                              passwordChanged = false,
                              result = true;
                          if (_profilePicture != null) {
                            if (g.imageUrl != "") {
                              bool removeimage =
                                  await Storage().deleteImage(g.imageUrl);
                              showToast(context, "error", "Error",
                                  "Unable to update your profile picture");
                              return;
                            }
                            newImageUrl = await Storage().storeImage(
                                "${g.society}/${g.uid}",
                                g.uid,
                                _profilePicture);
                            saveStatus = newImageUrl == null ? false : true;
                            message = newImageUrl == null
                                ? "Image was not uploaded suceessfully"
                                : "";
                          } else {
                            if (g.imageUrl != "") {
                              bool deleteResult =
                                  await Storage().deleteImage(g.imageUrl);
                              saveStatus = deleteResult == false ? false : true;
                              message = deleteResult == false
                                  ? "Unable to remove Image"
                                  : "";
                            }
                          }
                          print("Savestatus " + saveStatus.toString());
                          if (!saveStatus) {
                            setState(() => isLoading = false);
                            showToast(context, "error", "Error", message);
                            return;
                          }
                          if (g.email != emailController.text) {
                            emailChanged = true;
                          }
                          if (passwordController.text != "" &&
                              oldPasswordController.text !=
                                  passwordController.text &&
                              oldPasswordController.text != "") {
                            passwordChanged = true;
                          }
                          print("Email change " +
                              emailChanged.toString() +
                              " PasswordChanged " +
                              passwordChanged.toString());
                          if (emailChanged && passwordChanged) {
                            print("EP");
                            result = await Auth().reAuthenticate(
                                g.email, oldPasswordController.text,
                                newEmail: emailController.text,
                                newPassword: passwordController.text);
                          } else if (emailChanged) {
                            print("E");
                            result = await Auth().reAuthenticate(
                                g.email, oldPasswordController.text,
                                newEmail: emailController.text);
                          } else if (passwordChanged) {
                            print("P");
                            result = await Auth().reAuthenticate(
                                g.email, oldPasswordController.text,
                                newPassword: passwordController.text);
                          }
                          saveStatus = result;
                          print("SaveStatus " +
                              saveStatus.toString() +
                              " Result " +
                              result.toString());
                          if (!saveStatus) {
                            setState(() => isLoading = false);
                            showToast(context, "error", "Error",
                                "An error occured while updating your credentials");
                            return;
                          }
                          Database()
                              .updateUserDetails(
                                  g.society,
                                  g.uid,
                                  fnameController.text,
                                  lnameController.text,
                                  emailController.text,
                                  phoneController.text,
                                  newImageUrl)
                              .then((value) {
                            g.setFname = fnameController.text;
                            g.setLname = lnameController.text;
                            g.setEmail = emailController.text;
                            g.setPhoneNum = phoneController.text;
                            g.setImageUrl = newImageUrl;
                            setState(() => isLoading = false);
                            showToast(context, "success", "Success",
                                "Profile Updated Successfully");
                            Navigator.pop(context);
                          }).catchError((onError) {
                            setState(() => isLoading = false);
                            showToast(
                                context, "error", "Error", onError.toString());
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff037DD6)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
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
