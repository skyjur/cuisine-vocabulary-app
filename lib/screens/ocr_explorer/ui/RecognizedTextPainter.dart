import 'package:flutter/rendering.dart';
import 'package:foodvocabularyapp/service/text_recognition.dart';

class RecognizedTextOverlayPainter extends CustomPainter {
  RecognizedTextOverlayPainter(this.visionResult, this.selectedBlocks);

  final RecognizedText visionResult;
  final Iterable<NormalizedTextBlock> selectedBlocks;

  @override
  bool shouldRepaint(RecognizedTextOverlayPainter oldDelegate) {
    return !(identical(oldDelegate.visionResult, visionResult) &&
        oldDelegate.selectedBlocks.length == selectedBlocks.length);
  }

  @override
  paint(Canvas canvas, Size size) {
    final w = 1.0; // size.width;
    final h = 1.0; // size.height;
    // canvas.drawPath(Path().moveTo(0.0, 0.0), paint)
    for (final block in visionResult.blocks) {
      final isSelected = selectedBlocks.contains(block);

      final path = Path()
        ..moveTo(block.left, block.top)
        ..lineTo(block.right, block.top)
        ..lineTo(block.right, block.bottom)
        ..lineTo(block.left, block.bottom)
        ..lineTo(block.left, block.top);

      canvas.drawPath(
          path,
          Paint()
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..color = isSelected
                ? Color.fromARGB(100, 255, 100, 255)
                : Color.fromARGB(100, 100, 100, 255));
      // ..color = Color.fromARGB(100, 255, 0, 0));
    }
  }
}
