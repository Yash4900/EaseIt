import 'package:ease_it/utility/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/multiple_image_editor.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class SupportFeedback extends StatefulWidget {
  const SupportFeedback({Key key}) : super(key: key);

  @override
  State<SupportFeedback> createState() => _SupportFeedbackState();
}

class _SupportFeedbackState extends State<SupportFeedback> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> imageFiles = [];
  Globals g = Globals();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Support and Feedback",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
                          "You will be contacted through email for your query or complaint",
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
                Text(
                  "TITLE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                  child: TextFormField(
                    maxLength: 30,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Enter a title',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                    controller: _titleController,
                    validator: (value) =>
                        value.length == 0 ? 'Please enter a title' : null,
                  ),
                ),
                Text(
                  "Description",
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
                      hintText: 'Enter a description',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    controller: _descriptionController,
                    validator: (value) =>
                        value.length == 0 ? 'Please enter a title' : null,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                imageFiles.isEmpty
                    ? Material(
                        child: InkWell(
                          child: GestureDetector(
                            onTap: () async {
                              imageFiles = await PickImage()
                                  .showMultiPicker(context, 50);
                              if (imageFiles.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultipleImageEditor(
                                      imageFiles: imageFiles,
                                    ),
                                  ),
                                );
                              } else {}
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
                    : SizedBox(),
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
                          "You can select upto 7 images",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
