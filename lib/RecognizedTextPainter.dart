import 'package:flutter/rendering.dart';
import 'package:twfoodtranslations/utils/text_recognition.dart';

class RecognizedTextOverlayPainter extends CustomPainter {
  RecognizedTextOverlayPainter(this.visionResult, this.selectedBlocks);

  final RecognizedText visionResult;
  final Set<NormalizedTextBlock> selectedBlocks;

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
        ..moveTo(block.left * w, block.top * h)
        ..lineTo(block.right * w, block.top * h)
        ..lineTo(block.right * w, block.bottom * h)
        ..lineTo(block.left * w, block.bottom * h)
        ..lineTo(block.left * w, block.top * h);

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
