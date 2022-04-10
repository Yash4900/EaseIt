import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/firebase/storage.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/image/pick_image.dart';
import 'package:ease_it/utility/image/single_image_editor.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class UpdateProgress extends StatefulWidget {
  String complaintId;
  List progress;
  UpdateProgress({
    Key key,
    @required this.complaintId,
    @required this.progress,
  }) : super(key: key);

  @override
  State<UpdateProgress> createState() => _UpdateProgressState();
}

class _UpdateProgressState extends State<UpdateProgress> {
  bool loading = false;
  TextEditingController _contentController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File imageFile;
  Globals g = Globals();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            body: Loading(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "Update Progress",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () async {
                  bool confirmation = await showAlertDialog(context, 'Alert!',
                      'Are you sure you want to leave? Your changes will be discarded');
                  if (confirmation) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    //mainAxisAlignment: MainAxisAlignment.start,R
                    children: [
                      Text(
                        "Progress report",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: TextFormField(
                          maxLength: 150,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Enter the progress made',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(150),
                          ],
                          controller: _contentController,
                          validator: (value) => value.length == 0
                              ? 'Please enter the progress made'
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      imageFile == null
                          ? Material(
                              child: InkWell(
                                child: GestureDetector(
                                  onTap: () async {
                                    imageFile = await PickImage()
                                        .showPicker(context, 50);
                                    setState(() {});
                                    if (imageFile != null) {
                                      imageFile = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SingleImageEditor(
                                            imageFile: imageFile,
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
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                imageFile = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SingleImageEditor(imageFile: imageFile),
                                  ),
                                );
                                setState(() {});
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(imageFile),
                                  ),
                                ),
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "NOTE : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 12.5,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "You can select upto 1 image",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            bool confirmation = await showConfirmationDialog(
                                context,
                                "Alert!",
                                "Are you sure you want to update your progress?");
                            if (confirmation) {
                              setState(() {
                                loading = true;
                              });
                              DateTime currentTime = DateTime.now();
                              String newImageUrl;
                              if (imageFile != null) {
                                String timeOfImageUrl = currentTime
                                    .microsecondsSinceEpoch
                                    .toString();
                                newImageUrl = await Storage().storeImage(
                                    "complaints/${widget.complaintId}/progress",
                                    timeOfImageUrl,
                                    imageFile);
                                if (newImageUrl == null) {
                                  setState(() {
                                    loading = false;
                                  });
                                  showToast(context, "error", "Error",
                                      "Unable to upload Image");
                                  return;
                                }
                              }
                              if (newImageUrl == null) {
                                widget.progress.add({
                                  "content": _contentController.text,
                                  "postedBy": g.uid,
                                  "time": currentTime.toString(),
                                });
                              } else {
                                widget.progress.add({
                                  "content": _contentController.text,
                                  "postedBy": g.uid,
                                  "time": currentTime.toString(),
                                  "imageUrl": newImageUrl,
                                });
                              }
                              bool status = await Database()
                                  .updateProgressOfTheComplaint(g.society,
                                      widget.complaintId, widget.progress);
                              //update the progress
                              setState(() {
                                loading = false;
                              });
                              if (status) {
                                Navigator.pop(context);
                                showToast(context, "success", "Success",
                                    "Progress Updated");
                              } else {
                                widget.progress.isNotEmpty ??
                                    widget.progress.removeLast();
                                showToast(context, "error", "Error",
                                    "Could not update progress");
                              }
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xff037DD6)),
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
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
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
