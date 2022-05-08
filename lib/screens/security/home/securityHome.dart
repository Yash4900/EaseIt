import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/security/approval/code_approval.dart';
import 'package:ease_it/utility/acknowledgement/alert.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class SecurityHome extends StatefulWidget {
  @override
  _SecurityHomeState createState() => _SecurityHomeState();
}

class _SecurityHomeState extends State<SecurityHome> {
  Globals g = Globals();
  TextEditingController _codeController = TextEditingController();

  void onClick() {
    setState(() {});
  }

  Future<void> verifyVisitor(String code) async {
    print(code);
    QueryDocumentSnapshot qds = await Database().verifyByCode(g.society, code);
    if (qds == null) {
      showMessageDialog(context, 'Invalid Code!', [
        Center(
          child: Image.asset(
            'assets/error.png',
            width: 230,
          ),
        ),
        Center(
          child: Text(
            'The code provided by visitor does not exists or is expired!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 16,
            ),
          ),
        ),
      ]);
    } else {
      int code;
      try {
        code = qds['code'];
      } catch (e) {
        print(e.toString());
      }
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) => CodeApproval(
            qds.id,
            qds['name'],
            qds['purpose'],
            code != null ? 'Daily Helper' : 'Pre Approved Visitor',
            qds['imageUrl'] ?? '',
          ),
        ),
      );
    }
    setState(() => _codeController.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: _codeController.text == ""
                  ? Text('Enter Visitor Code in the Keypad',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  : Text(
                      _codeController.text,
                      style:
                          GoogleFonts.urbanist(fontSize: 30, letterSpacing: 2),
                    ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Button(1, _codeController, onClick),
                      Button(2, _codeController, onClick),
                      Button(3, _codeController, onClick)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Button(4, _codeController, onClick),
                      Button(5, _codeController, onClick),
                      Button(6, _codeController, onClick)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Button(7, _codeController, onClick),
                      Button(8, _codeController, onClick),
                      Button(9, _codeController, onClick)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          highlightColor: Color(0xff037DD6),
                          onTap: () {
                            if (_codeController.text.length > 0) {
                              _codeController.text = _codeController.text
                                  .substring(
                                      0, _codeController.text.length - 1);
                              setState(() {});
                            }
                          },
                          child: Container(
                            color: Colors.grey[100],
                            margin: EdgeInsets.all(3),
                            child: Center(
                              child:
                                  Image.asset('assets/cancel.png', height: 25),
                            ),
                          ),
                        ),
                      ),
                      Button(0, _codeController, onClick),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff037DD6)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      verifyVisitor(_codeController.text);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Verify Visitor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xffd7373f)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // Platform messages may fail, so we use a try/catch PlatformException.
                      try {
                        var result = await BarcodeScanner.scan(
                            options: ScanOptions(
                                restrictFormat: [BarcodeFormat.qr]));
                        await verifyVisitor(result.rawContent.toString());
                      } catch (e) {
                        print("-------------------EXCEPTION----------------");
                        print(e.toString());
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            'Scan QR Code',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final int value;
  final TextEditingController controller;
  final Function onClick;
  Button(this.value, this.controller, this.onClick);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        highlightColor: Color(0xff037DD6),
        onTap: () {
          if (controller.text.length < 6) {
            controller.text = controller.text + value.toString();
            onClick();
          }
        },
        child: Container(
          color: Colors.grey[100],
          margin: EdgeInsets.all(3),
          child: Center(
            child: Text(
              value.toString(),
              style: GoogleFonts.urbanist(
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
