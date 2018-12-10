import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RecognizedTextBox extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var gradient = new RadialGradient(
      center: const Alignment(0.7, -0.6),
      radius: 0.2,
      colors: [const Color(0xFFFFFF00), const Color(0xFF0099FF)],
      stops: [0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      new Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(RecognizedTextBox oldDelegate) => false;

  // @override
  // SemanticsBuilderCallback get semanticsBuilder {
  //   return (Size size) {
  //     // Annotate a rectangle containing the picture of the sun
  //     // with the label "Sun". When text to speech feature is enabled on the
  //     // device, a user will be able to locate the sun on this picture by
  //     // touch.
  //     var rect = Offset.zero & size;
  //     var width = size.shortestSide * 0.4;
  //     rect = const Alignment(0.8, -0.9).inscribe(new Size(width, width), rect);
  //     return [
  //       new CustomPainterSemantics(
  //         rect: rect,
  //         properties: new SemanticsProperties(
  //           label: 'Sun',
  //           textDirection: TextDirection.ltr,
  //         ),
  //       ),
  //     ];
  //   };
  // }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.

  // @override
  // bool shouldRebuildSemantics(RecognizedTextBox oldDelegate) => false;
}
