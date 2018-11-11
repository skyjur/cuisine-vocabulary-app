import 'dart:async';
import 'dart:io' as Io;
import 'dart:math' as Math;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';

class _ResizeImageFileOptions {
  String inputFileName;
  String outputFileName;
  int maxResolution;
  _ResizeImageFileOptions(
      this.inputFileName, this.outputFileName, this.maxResolution);
}

class ResizeResult {
  int width;
  int height;
  ResizeResult(this.width, this.height);
}

ResizeResult _resizeImageAndWriteJpg(_ResizeImageFileOptions opts) {
  final inputBytes = Io.File(opts.inputFileName).readAsBytesSync();
  Image originalImage = decodeImage(inputBytes);
  final ratio =
      (originalImage.width * originalImage.height) / opts.maxResolution;
  final width = originalImage.width ~/ ratio;
  final height = originalImage.height ~/ ratio;
  Image resizedImage = copyResize(originalImage, width, height);
  List<int> encodedInput = encodeJpg(resizedImage, quality: 95);
  final outFile = Io.File(opts.outputFileName);
  outFile.writeAsBytesSync(encodedInput);
  return ResizeResult(width, height);
}

Future<ResizeResult> resizeImageAndWriteJpg(
    String inputFileName, String outputFileName, int maxResolution) {
  return compute(_resizeImageAndWriteJpg,
      _ResizeImageFileOptions(inputFileName, outputFileName, maxResolution));
}
