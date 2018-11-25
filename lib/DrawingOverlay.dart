import 'package:flutter/material.dart';

class DrawingOverlay extends StatefulWidget {
  DrawingOverlay({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _DrawingOverlay createState() => _DrawingOverlay();
}

class _DrawingOverlay extends State<DrawingOverlay> {
  final path = Path();
  int updates = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanStart: (args) {
          setState(() {
            Offset pos = (context.findRenderObject() as RenderBox)
                .globalToLocal(args.globalPosition);
            path.reset();
            path.moveTo(pos.dx, pos.dy);
          });
        },
        onPanUpdate: (args) {
          setState(() {
            updates++;
            Offset pos = (context.findRenderObject() as RenderBox)
                .globalToLocal(args.globalPosition);
            path.lineTo(pos.dx, pos.dy);
          });
        },
        child: CustomPaint(
          foregroundPainter: PathPainter(updates, path),
          child: this.widget.child,
        ));
  }
}

class PathPainter extends CustomPainter {
  final int updates;
  final Path path;
  PathPainter(this.updates, this.path);

  @override
  bool shouldRepaint(PathPainter oldDelegate) {
    return oldDelegate.updates != updates;
  }

  @override
  paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..color = Color.fromARGB(100, 255, 255, 255);
    canvas.drawPath(path, paint);
  }
}
