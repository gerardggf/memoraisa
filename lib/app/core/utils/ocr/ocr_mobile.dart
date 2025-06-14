import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> extractTextFromImageBytes(Uint8List bytes) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/temp_img.jpg');
    await file.writeAsBytes(bytes);

    final inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    return recognizedText.text;
  } catch (e) {
    return null;
  }
}
