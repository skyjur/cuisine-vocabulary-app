import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:twfoodtranslations/dictionary.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:twfoodtranslations/utils/position_index.dart';

// class VisionResult implements VisionText {
//   // It's important to know width & height of source image to correctly transpose
//   // results when drawing it on source image.
//   final int imgWidth;
//   final int imgHeight;
//   final String text;
//   final List<TextBlock> blocks;
//   final PositionIndex _index;
//   VisionResult(this.text, this.blocks, this.imgWidth, this.imgHeight)
//       : _index = createIndex(blocks);

//   static PositionIndex createIndex(List<TextBlock> blocks) {
//     var idx = PositionIndex<TextBlock>(blocks.expand((block) {
//       final box = block.boundingBox;
//       final left = box.left.toDouble();
//       final right = box.right.toDouble();
//       final top = box.top.toDouble();
//       final bottom = box.bottom.toDouble();
//       return [
//         PositionedObj(Offset(left, top), block),
//         PositionedObj(Offset(right, top), block),
//         PositionedObj(Offset(left, bottom), block),
//         PositionedObj(Offset(right, bottom), block),
//       ];
//     }));
//     return idx;
//   }

//   List<TextBlock> findInRadius(Offset pos, double radius) {
//     return _index.findInRadius(pos, radius);
//   }
// }

class RecognizedText {
  RecognizedText(this.image, this.width, this.height, this.blocks)
      : _index = _createIndex(blocks);

  final List<NormalizedTextBlock> blocks;
  final PositionIndex<NormalizedTextBlock> _index;
  final File image;
  int width;
  int height;

  static PositionIndex _createIndex(List<NormalizedTextBlock> blocks) {
    return PositionIndex<NormalizedTextBlock>(blocks.map((block) =>
        PositionedObj(block,
            top: block.top,
            right: block.right,
            bottom: block.bottom,
            left: block.left)));
  }

  List<NormalizedTextBlock> findInRadius(Offset pos, double radius) {
    return _index.findInRadius(pos, radius).toList();
  }
}

Future<RecognizedText> recognizeText(String inputFilePath) async {
  final TextRecognizer textRecognizer =
      FirebaseVision.instance.cloudTextRecognizer();
  final inputImageSize =
      await FlutterNativeImage.getImageProperties(inputFilePath);
  final ratio =
      max((inputImageSize.width * inputImageSize.height) / (2000 * 2000), 1.0);
  int targetWidth = inputImageSize.width ~/ ratio;
  int targetHeight = inputImageSize.height ~/ ratio;
  final resultImage = await FlutterNativeImage.compressImage(inputFilePath,
      quality: 90, targetWidth: targetWidth, targetHeight: targetHeight);
  final visionImage = FirebaseVisionImage.fromFilePath(resultImage.path);
  final visionText = await textRecognizer.processImage(visionImage);
  return RecognizedText(
      resultImage,
      targetWidth,
      targetHeight,
      normalizeTextBlocks(
          visionText, ratio, targetWidth.toDouble(), targetHeight.toDouble()));
}

// Future<VisionResult> recognizeText(String inputFilePath) async {
//   final TextRecognizer textRecognizer =
//       FirebaseVision.instance.cloudTextRecognizer();
//   final resizedFilePath = await makeTempFileName();
//   final t = DateTime.now();
//   final resizedImage =
//       await resizeImageAndWriteJpg(inputFilePath, resizedFilePath, 1800 * 1800);
//   final d = DateTime.now().millisecondsSinceEpoch - t.millisecondsSinceEpoch;
//   print('imageResizeTimeDuration: $d');
//   final visionImage = FirebaseVisionImage.fromFilePath(resizedFilePath);
//   final visionText = await textRecognizer.processImage(visionImage);
//   return VisionResult(visionText.text, visionText.blocks, resizedImage.width,
//       resizedImage.height);
// }

class NormalizedTextBlock {
  final String text;
  final double top;
  final double left;
  final double right;
  final double bottom;
  const NormalizedTextBlock(
      {@required this.text,
      @required this.top,
      @required this.left,
      @required this.right,
      @required this.bottom});

  // operator ==(dynamic other) {
  //   return other.text == text;
  // }

  // @override
  // int get hashCode => this.text.hashCode;

  List<Term> get termMatch =>
      Dictionary.where((t) => t.term.contains(text)).toList();
}

List<NormalizedTextBlock> normalizeTextBlocks(
    VisionText visionText, double ratio, double width, double height) {
  print('ratio $ratio');
  var result = <NormalizedTextBlock>[];
  for (var block in visionText.blocks) {
    for (var fullLine in block.lines) {
      for (var elm in fullLine.elements) {
        // remove all ASCII symbols - we only care about chinese characters:
        final text = cleanText(elm.text);

        if (text != '') {
          // print(
          //     '$text ${elm.boundingBox.top}x${elm.boundingBox.left} ${elm.boundingBox.width}x${elm.boundingBox.height}');

          result.add(NormalizedTextBlock(
            text: text,
            top: elm.boundingBox.top.toDouble(), // / height,
            left: elm.boundingBox.left.toDouble(), // / width,
            bottom: elm.boundingBox.bottom.toDouble(), // / height,
            right: elm.boundingBox.right.toDouble(), // / width,
          ));
        }
      }
    }
  }
  return result;
}

String cleanText(String text) {
  return text
      .replaceAll(RegExp(r'[^\u4E00-\u9FA5]'), '')
      .replaceAll('一', '')
      .trim();
}
