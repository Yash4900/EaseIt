import 'dart:math';

import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/Approval/approvalHome.dart';
import 'package:ease_it/screens/resident/maintenance/secretaryPOV.dart';
import 'package:ease_it/utility/variables/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';

class PreApproval extends StatefulWidget {
  @override
  _PreApprovalState createState() => _PreApprovalState();
}

class _PreApprovalState extends State<PreApproval> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Allow Future Enteries', style: Helper().headingStyle),
        ],
      ),
      content: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Create pre approval entry of expected visitor to ensure hassle-free entry for them",
                style: Helper().normalStyle),
            Row(
              children: [
                CircularButtonIcon2(
                  firstName: "Guest",
                  lastName: "",
                  imageLink: 'assets/guest.png',
                  type: 'guest',
                ),
                CircularButtonIcon2(
                  firstName: "Taxi",
                  lastName: "",
                  imageLink: 'assets/taxi.png',
                  type: 'taxi',
                ),
                CircularButtonIcon2(
                  firstName: "Delivery",
                  lastName: "",
                  imageLink: 'assets/delivery-man.png',
                  type: 'delivery',
                ),
                CircularButtonIcon2(
                  firstName: "Visiting",
                  lastName: "Help",
                  imageLink: 'assets/technical-support.png',
                  type: 'visitingHelp',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircularButtonIcon2 extends StatelessWidget {
  final String firstName, lastName, type, imageLink;

  final String guestImageLink =
      "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/utility%2Fguest.png?alt=media&token=fc905aca-7189-442d-b3a2-5b3dee65d12e";
  int generateCode() {
    var random = Random();
    int code = 0;
    for (int i = 0; i < 6; i++) {
      code = (code * 10 + random.nextInt(9) + 1);
    }
    return code;
  }

  Future<void> share(String code) async {
    await FlutterShare.share(
        title: "EaseIt PreapprovalCode", text: "PreApproval Code : " + code);
  }

  CircularButtonIcon2(
      {this.firstName, this.lastName, this.imageLink, this.type});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        Navigator.of(context).pop();
        switch (type) {
          case "guest":
            {
              Future<PermissionStatus> _getContactPermission() async {
                PermissionStatus permission = await Permission.contacts.status;
                if (permission != PermissionStatus.granted &&
                    permission != PermissionStatus.permanentlyDenied) {
                  PermissionStatus permissionStatus =
                      await Permission.contacts.request();
                  return permissionStatus;
                } else {
                  return permission;
                }
              }

              TextEditingController nameController = TextEditingController();
              TextEditingController phoneController = TextEditingController();
              TextEditingController vehicleNo = TextEditingController();
              // TextEditingController wing = TextEditingController();

              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Select Guest to Invite",
                            style: Helper().headingStyle),
                        content: Container(
                          decoration: new BoxDecoration(
                            // shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: AssetImage("assets/bg.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularImageIcon(
                                      firstName: "From",
                                      lastName: "Contact",
                                      imageLink: guestImageLink,
                                      operation: () async {
                                        PermissionStatus permissionStatus =
                                            await _getContactPermission();
                                        if (permissionStatus ==
                                            PermissionStatus.granted) {
                                          List<Contact> _contacts =
                                              await ContactsService.getContacts(
                                                  withThumbnails: false);

                                          return showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text(
                                                        "Select from the below contact"),
                                                    content: Container(
                                                        child: ListView.builder(
                                                      itemCount:
                                                          _contacts?.length ??
                                                              0,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        Contact contact =
                                                            _contacts
                                                                ?.elementAt(
                                                                    index);
                                                        if (contact
                                                                .phones.length >
                                                            0) {
                                                          return ListTile(
                                                            onTap: () {
                                                              nameController
                                                                      .text =
                                                                  contact
                                                                      .displayName;
                                                              // Item x=contact.phones[0];
                                                              contact.phones.map(
                                                                  (e) => print(
                                                                      e.value));
                                                              contact.emails.map(
                                                                  (e) => print(
                                                                      e.value));
                                                              print("Hello");
                                                              // contact..map((e) => print(e.value));

                                                              phoneController
                                                                      .text =
                                                                  contact
                                                                      .phones[0]
                                                                      .value
                                                                      .toString();

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 2,
                                                                    horizontal:
                                                                        18),
                                                            leading: (contact
                                                                            .avatar !=
                                                                        null &&
                                                                    contact
                                                                        .avatar
                                                                        .isNotEmpty)
                                                                ? CircleAvatar(
                                                                    backgroundImage:
                                                                        MemoryImage(
                                                                            contact.avatar),
                                                                  )
                                                                : CircleAvatar(
                                                                    child: Text(
                                                                        contact
                                                                            .initials()),
                                                                    backgroundColor:
                                                                        Theme.of(context)
                                                                            .accentColor,
                                                                  ),
                                                            title: Text(contact
                                                                    .displayName ??
                                                                ''),
                                                            //This can be further expanded to showing contacts detail
                                                            // onPressed().
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    )),
                                                  ));
                                        } else {
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  'Contact data not available on device'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      }),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter name',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    controller: nameController,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter phoneNo',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: phoneController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter VehicleNo',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    // keyboardType: TextInputType.number,
                                    controller: vehicleNo,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      int code = generateCode();
                                      await Database().addPreApprovalEntry(
                                          g.society,
                                          nameController.text,
                                          phoneController.text,
                                          vehicleNo.text,
                                          Map<String, String>.from(g.flat),
                                          //g.flatNo,
                                          //g.wing,
                                          code.toString(),
                                          "Guest",
                                          "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/utility%2Fguest.png?alt=media&token=fc905aca-7189-442d-b3a2-5b3dee65d12e");

                                      final popup = BeautifulPopup(
                                        context: context,
                                        template: TemplateNotification,
                                      );

                                      popup.show(
                                          title: "TOKEN",
                                          content: Column(
                                            children: [
                                              Text(
                                                code.toString(),
                                                style: Helper().headingStyle,
                                              )
                                            ],
                                          ),
                                          actions: [
                                            popup.close,
                                            popup.button(
                                              label: 'Close',
                                              onPressed: () {
                                                int count = 2;
                                                Navigator.of(context).popUntil(
                                                    (_) => count-- <= 0);
                                              },
                                            ),
                                            popup.button(
                                              label: 'Share Code',
                                              onPressed: () {
                                                share(code.toString());
                                              },
                                            ),
                                          ]);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff1a73e8)),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 2, 10, 2),
                                      child: Text(
                                        'Generate Token',
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
                      ));
            }

            break;
          case "taxi":
            {
              TextEditingController nameController = TextEditingController();
              TextEditingController phoneController = TextEditingController();
              TextEditingController carController = TextEditingController();
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Allow my cab to enter today in next ",
                            style: Helper().headingStyle),
                        content: Container(
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/bg.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter the name',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    controller: nameController,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter phone Number',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: phoneController,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter car Number',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: carController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      int code = generateCode();
                                      Database().addPreApprovalEntry(
                                          g.society,
                                          nameController.text,
                                          phoneController.text,
                                          carController.text,
                                          g.flat,
                                          //g.wing,
                                          code.toString(),
                                          "Cab",
                                          "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/utility%2Ftaxi.png?alt=media&token=f73f031a-b1fc-4537-84ed-b8a67db4941b");
                                      final popup = BeautifulPopup(
                                        context: context,
                                        template: TemplateNotification,
                                      );

                                      popup.show(
                                          title: "TOKEN",
                                          content: Column(
                                            children: [
                                              Text(
                                                code.toString(),
                                                style: Helper().headingStyle,
                                              )
                                            ],
                                          ),
                                          actions: [
                                            popup.close,
                                            popup.button(
                                              label: 'Close',
                                              onPressed: () {
                                                int count = 2;
                                                Navigator.of(context).popUntil(
                                                    (_) => count-- <= 0);
                                              },
                                            ),
                                          ]);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff1a73e8)),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 2, 10, 2),
                                      child: Text(
                                        'Generate Token',
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
                      ));
            }
            break;
          case "delivery":
            {
              TextEditingController vehicleController = TextEditingController();
              TextEditingController nameController = TextEditingController();
              TextEditingController phoneController = TextEditingController();
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                            "Allow Delivery Guy to enter today in next ",
                            style: Helper().headingStyle),
                        content: Container(
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/bg.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter the Name',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    controller: nameController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter Phone Number',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: phoneController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter Vehicle Number',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: vehicleController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      int code = generateCode();
                                      Database().addPreApprovalEntry(
                                          g.society,
                                          nameController.text,
                                          phoneController.text,
                                          vehicleController.text,
                                          g.flat,
                                          //g.flatNo,
                                          //g.wing,
                                          code.toString(),
                                          "Delivery",
                                          "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/UtilityImage%2Fdelivery-man.png?alt=media&token=f0678091-2a3e-4958-a289-3c44e5b39880");

                                      final popup = BeautifulPopup(
                                        context: context,
                                        template: TemplateNotification,
                                      );

                                      popup.show(
                                          title: "TOKEN",
                                          content: Column(
                                            children: [
                                              Text(
                                                code.toString(),
                                                style: Helper().headingStyle,
                                              )
                                            ],
                                          ),
                                          actions: [
                                            popup.close,
                                            popup.button(
                                              label: 'Close',
                                              onPressed: () {
                                                int count = 2;
                                                Navigator.of(context).popUntil(
                                                    (_) => count-- <= 0);
                                              },
                                            ),
                                          ]);
                                      //   Navigator.of(context).pop();
                                      // Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff1a73e8)),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 2, 10, 2),
                                      child: Text(
                                        'Generate Token',
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
                      ));
            }
            break;
          case "visitingHelp":
            {
              TextEditingController nameController = TextEditingController();
              TextEditingController vehicleController = TextEditingController();
              TextEditingController phoneController = TextEditingController();
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Allow my technical helper ",
                            style: Helper().headingStyle),
                        content: Container(
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/bg.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter the name',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    controller: nameController,
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter the phone Number',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: phoneController,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter vehicle number',
                                      hintStyle: TextStyle(fontSize: 14),
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: vehicleController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      int code = generateCode();
                                      Database().addPreApprovalEntry(
                                          g.society,
                                          nameController.text,
                                          phoneController.text,
                                          vehicleController.text,
                                          g.flat,
                                          //g.flatNo,
                                          //g.wing,
                                          code.toString(),
                                          "VisitingHelp",
                                          "https://firebasestorage.googleapis.com/v0/b/ease-it-bfceb.appspot.com/o/UtilityImage%2Ftechnical-support.png?alt=media&token=c4112d24-bb2e-4d4c-8906-c32804845794");

                                      final popup = BeautifulPopup(
                                        context: context,
                                        template: TemplateNotification,
                                      );

                                      popup.show(
                                          title: "TOKEN",
                                          content: Column(
                                            children: [
                                              Text(
                                                code.toString(),
                                                style: Helper().headingStyle,
                                              )
                                            ],
                                          ),
                                          actions: [
                                            popup.close,
                                            popup.button(
                                              label: 'Close',
                                              onPressed: () {
                                                int count = 2;
                                                Navigator.of(context).popUntil(
                                                    (_) => count-- <= 0);
                                              },
                                            ),
                                          ]);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff1a73e8)),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 2, 10, 2),
                                      child: Text(
                                        'Generate Token',
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
                      ));
            }
        }
      },
      child: Container(
        // width: 45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(imageLink), fit: BoxFit.fill),
                ),
              ),
            ),
            Text(firstName, style: Helper().normalStyle),
            Text(lastName, style: Helper().normalStyle)
          ],
        ),
      ),
    );
  }
}
