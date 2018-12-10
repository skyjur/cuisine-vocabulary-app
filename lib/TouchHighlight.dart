import 'package:flutter/material.dart';

class TouchHighlight extends StatefulWidget {
  TouchHighlight(
      {Key key,
      this.getStrokeWidth,
      this.child,
      this.onHighlightMove,
      this.onHighlightReset,
      this.onHighlightEnd})
      : super(key: key);

  final Widget child;
  final double Function() getStrokeWidth;
  final void Function() onHighlightReset;
  final void Function(Offset position, double radius) onHighlightMove;
  final void Function() onHighlightEnd;

  @override
  _DrawingOverlay createState() => _DrawingOverlay();
}

class TrackPoint {
  TrackPoint(this.position, this.isStart, this.radius);
  Offset position;
  bool isStart;
  double radius;
}

class _DrawingOverlay extends State<TouchHighlight> {
  final path = Path();
  final List<TrackPoint> trackPoints = [];
  bool stopTracking = false;

  double strokeWidth = 10.0;
  List<int> pointers = [];
  int pointer;
  Offset startPoint;

  PointerEvent lastEvent;

  onPointerDown(PointerDownEvent event) {
    print('pointer down ${event.pointer} $pointers');
    pointers.add(event.pointer);
    setState(() {
      if (pointers.length > 1) {
        lastEvent = null;
        trackPoints.clear();
        widget.onHighlightReset();
      } else {
        if (lastEvent == null ||
            event.timeStamp - lastEvent.timeStamp >
                Duration(milliseconds: 500)) {
          trackPoints.clear();
          widget.onHighlightReset();
        }
        lastEvent = event;
        final box = (context.findRenderObject() as RenderBox);
        Offset pos = box.globalToLocal(event.position);
        final radius = widget.getStrokeWidth();
        trackPoints.add(TrackPoint(pos, true, radius));
        widget.onHighlightMove(pos, radius);
      }
    });
  }

  void onPointerMove(PointerMoveEvent event) {
    // print('pointer move ${event.pointer} $pointers');
    if (pointers.length == 1 &&
        lastEvent != null &&
        lastEvent.pointer == event.pointer) {
      lastEvent = event;
      setState(() {
        Offset pos = (context.findRenderObject() as RenderBox)
            .globalToLocal(event.position);
        final radius = widget.getStrokeWidth();
        trackPoints.add(TrackPoint(pos, false, radius));
        widget.onHighlightMove(pos, radius);
      });
    }
  }

  onPointerUp(PointerUpEvent event) {
    print('pointer up ${event.pointer} $pointers');
    pointers.remove(event.pointer);
    widget.onHighlightEnd();
  }

  onPointerCancel(PointerCancelEvent event) {
    print('pointer cancel ${event.pointer} $pointers');
    pointers.remove(event.pointer);
    widget.onHighlightEnd();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: onPointerDown,
        onPointerUp: onPointerUp,
        onPointerMove: onPointerMove,
        onPointerCancel: onPointerCancel,
        behavior: HitTestBehavior.translucent,
        child: CustomPaint(
          foregroundPainter: TrackPainter(trackPoints),
          child: this.widget.child,
        ));
  }
}

class TrackPainter extends CustomPainter {
  final List<TrackPoint> trackPoints;
  final TrackPoint last;

  TrackPainter(this.trackPoints)
      : last = trackPoints.length > 0 ? trackPoints.last : null;

  @override
  bool shouldRepaint(TrackPainter oldDelegate) {
    return !identical(oldDelegate.last, last);
  }

  @override
  paint(Canvas canvas, Size size) {
    // print('radius $radius');
    final color = Color.fromARGB(100, 255, 255, 255);
    // print('trackpoints ${trackPoints.length}');
    if (trackPoints.length > 1) {
      final paint = Paint()
        ..strokeWidth = trackPoints.first.radius
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..color = color;
      final path = Path();
      var p = trackPoints[0].position;
      path.moveTo(p.dx, p.dy);
      for (var i = 1; i < trackPoints.length; i++) {
        p = trackPoints[i].position;
        if (trackPoints[i].isStart) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(path, paint);
    } else if (trackPoints.length == 1) {
      canvas.drawCircle(
          last.position,
          last.radius / 2.0,
          Paint()
            ..style = PaintingStyle.fill
            ..color = color);
    } else {}
  }
}
