import 'dart:io' as Io;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:twfoodtranslations/utils/files.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart';
import 'package:flutter/services.dart';
import 'package:twfoodtranslations/utils/image.dart';

class VisionResult implements VisionText {
  // It's important to know width & height of source image to correctly transpose
  // results when drawing it on source image.
  final int imgWidth;
  final int imgHeight;
  final String text;
  final List<TextBlock> blocks;
  VisionResult(this.text, this.blocks, this.imgWidth, this.imgHeight);
}

Future<VisionResult> recognizeText(String inputFilePath) async {
  final TextRecognizer textRecognizer =
      FirebaseVision.instance.cloudTextRecognizer();
  final resizedFilePath = await makeTempFileName();
  final imageSize =
      await resizeImageAndWriteJpg(inputFilePath, resizedFilePath, 2000 * 2000);
  final visionImage = FirebaseVisionImage.fromFilePath(resizedFilePath);
  final visionText = await textRecognizer.processImage(visionImage);
  return VisionResult(
      visionText.text, visionText.blocks, imageSize.width, imageSize.height);
}
