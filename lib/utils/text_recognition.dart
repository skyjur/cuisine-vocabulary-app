import 'dart:io' as Io;
import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
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
  // final resizedFilePath = await makeTempFileName();
  final t = DateTime.now();
  final inputImageSize =
      await FlutterNativeImage.getImageProperties(inputFilePath);
  final ratio =
      max((inputImageSize.width * inputImageSize.height) / (2000 * 2000), 1);
  int targetWidth = inputImageSize.width ~/ ratio;
  int targetHeight = inputImageSize.height ~/ ratio;
  final resultImage = await FlutterNativeImage.compressImage(inputFilePath,
      quality: 90, targetWidth: targetWidth, targetHeight: targetHeight);
  print('resultImage ${resultImage.path}');
  final imageSize =
      await FlutterNativeImage.getImageProperties(resultImage.path);
  // await resizeImageAndWriteJpg(inputFilePath, resizedFilePath, 1800 * 1800);
  final d = DateTime.now().millisecondsSinceEpoch - t.millisecondsSinceEpoch;
  print('imageResizeTimeDuration: $d');
  print('imageResultPath ${resultImage.path}');
  print('imageResultSize ${imageSize.width}x${imageSize.height}');
  final visionImage = FirebaseVisionImage.fromFilePath(resultImage.path);
  final visionText = await textRecognizer.processImage(visionImage);
  return VisionResult(
      visionText.text, visionText.blocks, targetWidth, targetHeight);
}
