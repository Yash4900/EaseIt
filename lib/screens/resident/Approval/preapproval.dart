import 'package:ease_it/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreApproval extends StatefulWidget {
  // const PreApproval({ Key? key }) : super(key: key);

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
          Text(
            'Allow Future Enteries',
            style: GoogleFonts.montserrat(textStyle: Helper().headingStyle),
          ),
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
              style: GoogleFonts.montserrat(textStyle: Helper().normalStyle),
            ),
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
  String firstName, lastName, type;

  String imageLink;
  CircularButtonIcon2(
      {this.firstName, this.lastName, this.imageLink, this.type});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        switch (type) {
          case "guest":
            {
              TextEditingController nameController = TextEditingController();
              TextEditingController phoneController = TextEditingController();
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          "Select Guest to Invite",
                          style: GoogleFonts.montserrat(
                              textStyle: Helper().headingStyle),
                        ),
                        content: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color(0xFFFFFF),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(32.0)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Enter email',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                controller: nameController,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                
                                decoration: InputDecoration(
                                  hintText: 'Enter email',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                keyboardType: TextInputType.number,
                                controller: phoneController,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                onPressed: () async {
                                  print(phoneController.text);
                                  print(nameController.text);

                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff1a73e8)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
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
                      ));
            }
            break;
          case "taxi":
            {
              TextEditingController hourController = TextEditingController();
              TextEditingController carController = TextEditingController();
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          "Allow my cab to enter today in next ",
                          style: GoogleFonts.montserrat(
                              textStyle: Helper().headingStyle),
                        ),
                        content: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color(0xFFFFFF),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(32.0)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Enter the hour',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                controller: hourController,
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
                                  

                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff1a73e8)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
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
                      ));
            }
            break;
            case "delivery":
            {
              TextEditingController companyController = TextEditingController();
              TextEditingController hourController = TextEditingController();
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          "Allow Delivery Guy to enter today in next ",
                          style: GoogleFonts.montserrat(
                              textStyle: Helper().headingStyle),
                        ),
                        content: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color(0xFFFFFF),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(32.0)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Enter the hour',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                controller: hourController,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                
                                decoration: InputDecoration(
                                  hintText: 'Enter Company Name',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                keyboardType: TextInputType.text,
                                controller: companyController,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                onPressed: () async {
                                  

                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff1a73e8)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
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
                      ));
            }
            break;
            case "visitingHelp":
            {
              TextEditingController hourController = TextEditingController();
              TextEditingController companyController = TextEditingController();
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          "Allow my cab to enter today in next ",
                          style: GoogleFonts.montserrat(
                              textStyle: Helper().headingStyle),
                        ),
                        content: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color(0xFFFFFF),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(32.0)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Enter the hour',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                controller: hourController,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                
                                decoration: InputDecoration(
                                  hintText: 'Enter company',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                keyboardType: TextInputType.text,
                                controller: companyController,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                onPressed: () async {
                                  

                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff1a73e8)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
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
            Text(firstName,
                style: GoogleFonts.montserrat(textStyle: Helper().normalStyle)),
            Text(lastName,
                style: GoogleFonts.montserrat(textStyle: Helper().normalStyle)),
          ],
        ),
      ),
    );
  }
}
