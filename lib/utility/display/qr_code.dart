// This is a dialog widget which will show the code and generated QR Code
// It can be shared with the visitor

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
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
        title: Text(
          "Visiting Pass Generated Successfully!",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Colors.white,
              child: ListBody(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 200,
                      child: QrImage(
                        backgroundColor: Colors.white,
                        data: code,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      code,
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
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
