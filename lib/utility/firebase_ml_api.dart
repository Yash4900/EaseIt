import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FirebaseMLApi {
  Future<String> recognizeText(File imageFile) async {
    final visionImage = FirebaseVisionImage.fromFile(imageFile);
    final textRecognizer = FirebaseVision.instance.textRecognizer();
    final visionText = await textRecognizer.processImage(visionImage);
    await textRecognizer.close();
    String text = extractText(visionText);
    return text;
  }

  String extractText(VisionText visionText) {
    RegExp regExp = RegExp(
      r"(0D|[A-Z]{2})[0-9]{1,2}[A-Z]{0,3}[0-9]{4}",
      caseSensitive: true,
      multiLine: false,
    );

    // Extract all the text from image
    String text = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          text = text + element.text;
        }
      }
    }

    print(text);
    // Remove all white spaces
    text = text.replaceAll(" ", "");
    print(text);
    // Remove all characters other than capital alphabets and digits
    text = text.replaceAll(RegExp(r"[^A-Z0-9]"), "");
    print(text);
    // Convert all O's to 0
    text = text.replaceAll("O", "0");

    print(text);
    // Extract license plate number from text
    if (regExp.hasMatch(text)) {
      text = regExp.stringMatch(text);
    }

    // Convert 0 at index 0 to O for Odisha - Special case
    if (text[0] == '0') text = text.replaceRange(0, 1, 'O');
    return text;
  }
}
