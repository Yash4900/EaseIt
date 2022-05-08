// This is a dialog widget which will show the code and generated QR Code
// It can be shared with the visitor

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<bool> showQRDialog(BuildContext context, String code) async {
  GlobalKey globalKey = new GlobalKey();

  Future<void> shareCode(String code) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.png').create();
    await file.writeAsBytes(pngBytes);

    await FlutterShare.shareFile(
        title: 'Visiting Pass',
        filePath: '${tempDir.path}/image.png',
        text: 'Your visiting code is $code',
        fileType: 'image/png');
  }

  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: ListBody(
                children: <Widget>[
                  Center(
                    child: Text(
                      'Visitor Gate Pass',
                      style: GoogleFonts.sourceSansPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Container(
                      width: 200,
                      child: QrImage(
                        backgroundColor: Colors.white,
                        data: code,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      code,
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      'Show QR Code at security desk.',
                      style: TextStyle(
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff037DD6)),
            ),
            child: Text(
              'Share',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            onPressed: () async {
              await shareCode(code);
            },
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey[300]),
            ),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}
