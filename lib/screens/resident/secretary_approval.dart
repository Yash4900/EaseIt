import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ease_it/utility/alert.dart';

class SecretaryApproval extends StatefulWidget {
  const SecretaryApproval({Key key}) : super(key: key);

  @override
  State<SecretaryApproval> createState() => _SecretaryApprovalState();
}

class _SecretaryApprovalState extends State<SecretaryApproval> {
  Globals g = Globals();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Resident Requests",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: StreamBuilder(
            stream: Database().getNumberOfPendingUsersForSociety(g.society),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data.docs.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                          stream: Database().streamOfUserBasedOnFlatNumber(
                              g.society,
                              Map<String, String>.from(
                                  snapshot.data.docs[index]["flat"])),
                          builder: (context, usersSnapshot) {
                            if (usersSnapshot.connectionState ==
                                ConnectionState.active) {
                              return PendingRequestCard(
                                singleUserData: snapshot.data.docs[index],
                              );
                            } else if (usersSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Loading();
                            } else {
                              return Text(
                                "Error loading the data",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          });
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_outlined,
                          color: Color(0xffc0c0c0),
                          size: 35,
                        ),
                        Text(
                          "No pending requests found",
                          style: TextStyle(
                            color: Color(0xffc0c0c0),
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outlined,
                          size: 35,
                          color: Colors.redAccent,
                        ),
                        Text(
                          "Error loading the data",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class PendingRequestCard extends StatefulWidget {
  final QueryDocumentSnapshot singleUserData;
  PendingRequestCard({Key key, @required this.singleUserData})
      : super(key: key);

  @override
  State<PendingRequestCard> createState() => _PendingRequestCardState();
}

class _PendingRequestCardState extends State<PendingRequestCard> {
  Globals g = Globals();
  // List<String> dropDownItemsRoles = [];
  // String selectedRole;
  String roleToCheckTheStreamFor;

  // void setDropDownListAndValue() async {
  //   bool result = await Database().isOwnerPresent(
  //       g.society, Map<String, String>.from(widget.singleUserData["flat"]));
  //   print("Result obtaine is: $result");
  //   if (result) {
  //     setState(() {
  //       dropDownItemsRoles = ["Owner", "Resident", "Tenant"];
  //       selectedRole = dropDownItemsRoles[0];
  //     });
  //   } else {
  //     setState(() {
  //       dropDownItemsRoles = ["Owner"];
  //       selectedRole = dropDownItemsRoles[0];
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    roleToCheckTheStreamFor = widget.singleUserData["homeRole"] == "Owner"
        ? "Owner"
        : widget.singleUserData["homeRole"] == "Resident"
            ? "Tenant"
            : "Resident";
    //setDropDownListAndValue();
  }

  @override
  Widget build(BuildContext context) {
    //print("Option: ${widget.singleUserData}");
    //print("Type: ${widget.singleUserData.runtimeType}");
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Color(0xfff0f0f0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xffc0c0c0),
            blurRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: widget.singleUserData["imageUrl"] == ""
                      ? Container(
                          width: 70,
                          height: 70,
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffd0d0d0),
                          ),
                        )
                      : Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffd0d0d0),
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.singleUserData["imageUrl"],
                              ),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          (widget.singleUserData["fname"] +
                                  " " +
                                  widget.singleUserData["lname"])
                              .toString(),
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          "+91-" +
                              (widget.singleUserData["phoneNum"]).toString(),
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          (widget.singleUserData["email"]).toString(),
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          FlatDataOperations(
                            hierarchy: g.hierarchy,
                            flatNum: Map<String, String>.from(
                                widget.singleUserData["flat"]),
                          ).returnStringFormOfFlatMap(),
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          (widget.singleUserData["role"]).toString(),
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          (widget.singleUserData["homeRole"]).toString(),
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    splashColor: Color(0xffc0c0c0),
                    highlightColor: Color(0xffa0a0a0),
                    focusColor: Color(0xffa0a0a0),
                    child: GestureDetector(
                        child: Icon(
                          Icons.call_outlined,
                          size: 25,
                        ),
                        onTap: () async {
                          try {
                            await launch(
                                'tel:${widget.singleUserData["phoneNum"]}');
                          } catch (e) {
                            print(e.toString());
                            showToast(context, "error", "Error",
                                "Oops! Something went wrong");
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xffc0c0c0),
            height: 2,
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: Database().getStreamOfRoleOfParticularUser(
                      g.society,
                      Map<String, String>.from(widget.singleUserData["flat"]),
                      roleToCheckTheStreamFor,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: widget.singleUserData["role"] == "Owner"
                                ? snapshot.data.docs.length == 1
                                    ? () {
                                        showMessageDialog(
                                          context,
                                          "Alert",
                                          [
                                            Text(
                                              "There is already an owner present for the flat ${FlatDataOperations(
                                                hierarchy: g.hierarchy,
                                                flatNum:
                                                    Map<String, String>.from(
                                                        widget.singleUserData[
                                                            "flat"]),
                                              ).returnStringFormOfFlatMap()} you cannot aceept another owner's request",
                                            ),
                                          ],
                                        );
                                      }
                                    : () async {
                                        bool result =
                                            await Database().updateStatus(
                                          g.society,
                                          widget.singleUserData["email"],
                                          "accepted",
                                        );
                                        if (result) {
                                          showToast(context, "success",
                                              "Success", "Request Accepted");
                                        } else {
                                          showToast(context, "error", "Error",
                                              "Oops! Something went wrong");
                                        }
                                      }
                                : snapshot.data.docs.length >= 1
                                    ? () {
                                        showMessageDialog(
                                          context,
                                          "Alert",
                                          [
                                            Text(
                                              "Since there are already $roleToCheckTheStreamFor(s) present in the ${FlatDataOperations(
                                                hierarchy: g.hierarchy,
                                                flatNum:
                                                    Map<String, String>.from(
                                                        widget.singleUserData[
                                                            "flat"]),
                                              ).returnStringFormOfFlatMap()} you cannot accept ${widget.singleUserData["role"]} for the flat",
                                            ),
                                          ],
                                        );
                                      }
                                    : () async {
                                        bool result =
                                            await Database().updateStatus(
                                          g.society,
                                          widget.singleUserData["email"],
                                          "accepted",
                                        );
                                        if (result) {
                                          showToast(context, "success",
                                              "Success", "Request Accepted");
                                        } else {
                                          showToast(context, "error", "Error",
                                              "Oops! Something went wrong");
                                        }
                                      },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: widget.singleUserData["homeRole"] ==
                                          "Owner"
                                      ? snapshot.data.docs.length == 1
                                          ? Colors.grey[500]
                                          : Colors.greenAccent
                                      : snapshot.data.docs.length >= 1
                                          ? Colors.grey[500]
                                          : Colors.greenAccent,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Accept",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: widget.singleUserData["homeRole"] ==
                                            "Owner"
                                        ? snapshot.data.docs.length == 1
                                            ? Colors.grey[500]
                                            : Colors.greenAccent
                                        : snapshot.data.docs.length >= 1
                                            ? Colors.grey[500]
                                            : Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  VerticalDivider(
                    color: Color(0xffa0a0a0),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () async {
                        bool result = await Database().updateStatus(
                          g.society,
                          widget.singleUserData["email"],
                          "rejected",
                        );
                        if (result) {
                          showToast(context, "success", "Success",
                              "Request rejected");
                        } else {
                          showToast(context, "error", "Error",
                              "Oops! Something went wrong");
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Reject",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
