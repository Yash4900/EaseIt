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
    String text = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          text = text + element.text;
        }
      }
    }
    return text;
  }
}
