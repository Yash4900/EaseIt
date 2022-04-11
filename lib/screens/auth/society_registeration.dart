import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/utility/image/multiple_image_editor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ease_it/utility/display/loading.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/image/pick_image.dart';
import 'package:ease_it/firebase/storage.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class SocietyRegisteration extends StatefulWidget {
  const SocietyRegisteration({Key key}) : super(key: key);

  @override
  State<SocietyRegisteration> createState() => _SocietyRegisterationState();
}

class _SocietyRegisterationState extends State<SocietyRegisteration> {
  TextEditingController _flatController = TextEditingController();
  TextEditingController _societyController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> imageFiles = [];
  List<Widget> imageSliderWidget = [];
  bool loading = false;

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
    return loading
        ? Scaffold(
            body: Loading(),
          )
        : Scaffold(
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
                                "Your society will be contacted in few days after your request for society registeration",
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
                        "FLAT",
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
                            hintText: 'Enter your flat number',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          controller: _flatController,
                          validator: (value) => value.length == 0
                              ? 'Please enter a flat number'
                              : null,
                        ),
                      ),
                      Text(
                        "SOCIETY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: TextFormField(
                          maxLength: 60,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Enter your society name',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60),
                          ],
                          controller: _societyController,
                          validator: (value) => value.length == 0
                              ? 'Please enter society name'
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "ADDRESS",
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
                            hintText: 'Enter your society address',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(150),
                          ],
                          controller: _addressController,
                          validator: (value) => value.length == 0
                              ? 'Please enter the address'
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "LANDMARK",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: TextFormField(
                          maxLength: 90,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter your society landmark',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(90),
                          ],
                          controller: _landmarkController,
                          validator: (value) => value.length == 0
                              ? 'Please enter landmark for your society'
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: TextFormField(
                          maxLength: 60,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60),
                          ],
                          controller: _emailController,
                          validator: (value) => value.length == 0
                              ? 'Please enter your email'
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "PHONE NUMBER",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Enter your phone number',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          controller: _phoneNumberController,
                          validator: (value) => value.length == 0
                              ? 'Please enter your phone number'
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      imageFiles == null || imageFiles.isEmpty
                          ? Material(
                              child: InkWell(
                                child: GestureDetector(
                                  onTap: () async {
                                    imageFiles = await PickImage()
                                        .showMultiPicker(context, 50);
                                    setState(() {});
                                    if (imageFiles.isNotEmpty) {
                                      imageFiles = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MultipleImageEditor(
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
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : returnCarouselWidget(imageFiles),
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
                                "You can select upto 5 images",
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
                                "Are you sure you want to submit your society registeration request");
                            if (confirmation) {
                              setState(() {
                                loading = true;
                              });
                              List<String> linkOfImages = [];
                              DateTime currentTime = DateTime.now();
                              String timeAtWhichUploaded =
                                  currentTime.millisecondsSinceEpoch.toString();
                              if (imageFiles.length != 0) {
                                for (int i = 0; i < imageFiles.length; i++) {
                                  String newImageUrl = await Storage().storeImage(
                                      "Society Registeration Request/$timeAtWhichUploaded",
                                      "${timeAtWhichUploaded}_$i",
                                      imageFiles[i]);
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
                              bool status = await Database()
                                  .uploadSocietyRegisterationRequest(
                                flatNumber: _flatController.text,
                                societyName: _societyController.text,
                                addressOfSociety: _addressController.text,
                                landMarkOfScoiety: _landmarkController.text,
                                emailId: _emailController.text,
                                phoneNumber: _phoneNumberController.text,
                                time: timeAtWhichUploaded,
                                imageLinkList: linkOfImages,
                              );
                              setState(() {
                                loading = false;
                              });
                              if (status) {
                                Navigator.pop(context);
                                showToast(context, "success", "Success",
                                    "Your society registeration request was submitted successfully");
                              } else {
                                showToast(context, "error", "Error",
                                    "Unable to post your request");
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
