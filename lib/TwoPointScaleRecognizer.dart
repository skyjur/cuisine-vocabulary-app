import 'dart:async';
import 'dart:math' show sqrt;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

typedef GestureScaleStartCallback = void Function(ScaleEventStart);
typedef GestureScaleUpdateCallback = void Function(ScaleEventUpdate);
typedef GestureScaleEndCallback = void Function(ScaleEventEnd);

/// Recognizes scaling and pannign when 2 fingers hit the pane
///
/// Original ScaleRecognizer extends from PanningRecognizer and
/// it works with one touch point.
/// This prevents
class TwoPointScaleRecognizer extends OneSequenceGestureRecognizer {
  TwoPointScaleRecognizer({Object debugOwner}) {
    pointerEventSink = StreamController();
    twoPointEventStream = mapToTwoPointEvents(pointerEventSink.stream);
    scaleEventStream = mapToScaleEvents(twoPointEventStream);
    scaleEventStream.listen((ScaleEvent event) {
      switch (event.runtimeType) {
        case ScaleEventStart:
          invokeCallback('onStart', () {
            resolve(GestureDisposition.accepted);
            onStart?.call(event);
          });
          break;
        case ScaleEventUpdate:
          invokeCallback('onUpdate', () => onUpdate?.call(event));
          break;
        case ScaleEventEnd:
          invokeCallback('onEnd', () {
            resolve(GestureDisposition.rejected);
            onEnd?.call(event);
          });
          break;
      }
    });
  }

  GestureScaleStartCallback onStart;
  GestureScaleUpdateCallback onUpdate;
  GestureScaleEndCallback onEnd;

  StreamController<PointerEvent> pointerEventSink;
  Stream<TwoPointEvent> twoPointEventStream;
  Stream<ScaleEvent> scaleEventStream;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
  }

  @override
  String get debugDescription => "twoPointScale";

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    pointerEventSink.add(event);
  }

  @override
  void rejectGesture(int pointer) {
    stopTrackingPointer(pointer);
    // print('reject pointer $pointer');
    pointerEventSink.add(PointerCancelEvent(pointer: pointer));
  }

  static GestureRecognizerFactoryWithHandlers<TwoPointScaleRecognizer>
      getFactory(
          {GestureScaleStartCallback onStart,
          GestureScaleUpdateCallback onUpdate,
          GestureScaleEndCallback onEnd,
          Object debugOwner}) {
    return GestureRecognizerFactoryWithHandlers(
        () => TwoPointScaleRecognizer(debugOwner: debugOwner),
        (TwoPointScaleRecognizer instance) {
      instance
        ..onStart = onStart
        ..onUpdate = onUpdate
        ..onEnd = onEnd;
    });
  }
}

enum StartUpdateEnd { Start, Update, End }

@immutable
abstract class TwoPointEvent {
  const TwoPointEvent(this.timeStamp, this.point1, this.point2);
  final Duration timeStamp;
  final Offset point1;
  final Offset point2;

  @override
  String toString() {
    return '$timeStamp, $point1, $point2';
  }
}

class TwoPointEventStart extends TwoPointEvent {
  TwoPointEventStart(Duration timeStamp, Offset point1, Offset point2)
      : super(timeStamp, point1, point2);
}

class TwoPointEventUpdate extends TwoPointEvent {
  TwoPointEventUpdate(Duration timeStamp, Offset point1, Offset point2)
      : super(timeStamp, point1, point2);
}

class TwoPointEventEnd extends TwoPointEvent {
  TwoPointEventEnd(Duration timeStamp, Offset point1, Offset point2)
      : super(timeStamp, point1, point2);
}

/// Consume stream of pointer events and notify when 2 points are used to interact.
Stream<TwoPointEvent> mapToTwoPointEvents(Stream<PointerEvent> events) async* {
  PointerEvent p1;
  PointerEvent p2;

  bool started = false;
  bool shouldStop = false;

  await for (var event in events) {
    switch (event.runtimeType) {
      case PointerDownEvent:
        // print('pointer down ${event.pointer}');
        if (p1 == null) {
          p1 = event;
        } else if (p2 == null) {
          p2 = event;
        } else {
          // 3rd pointer detected
          shouldStop = true;
        }
        break;
      case PointerMoveEvent:
        if (p1 != null && p2 != null) {
          if (!started) {
            started = true;
            yield TwoPointEventStart(event.timeStamp, p1.position, p2.position);
          }
          if (p1.pointer == event.pointer) {
            p1 = event;
          } else {
            p2 = event;
          }
          yield TwoPointEventUpdate(event.timeStamp, p1.position, p2.position);
        } else if (p1 != null) {
          if ((p1.position - event.position).distance > 10) {
            // abort if initial pointer travels too far from it's touch point
            shouldStop = true;
          }
        }
        break;
      case PointerUpEvent:
      case PointerCancelEvent:
        // print('pointer up ${event.pointer}');
        shouldStop = true;
        break;
    }

    if (shouldStop) {
      if (started) {
        yield TwoPointEventEnd(event.timeStamp, p1.position, p2.position);
      }
      shouldStop = false;
      started = false;
      p1 = null;
      p2 = null;
    }
  }
}

abstract class ScaleEvent {
  final double scale;
  final Offset offset;
  ScaleEvent(this.scale, this.offset);

  @override
  String toString() {
    return '$scale $offset';
  }
}

class ScaleEventStart extends ScaleEvent {
  ScaleEventStart() : super(1.0, Offset(0.0, 0.0));
}

class ScaleEventUpdate extends ScaleEvent {
  ScaleEventUpdate(double scale, Offset offset) : super(scale, offset);
}

class ScaleEventEnd extends ScaleEvent {
  ScaleEventEnd(double scale, Offset offset) : super(scale, offset);
}

Stream<ScaleEvent> mapToScaleEvents(Stream<TwoPointEvent> events) async* {
  double startDistanceSq;
  double lastScale = 1.0;
  Offset startPosition;
  Offset lastPosition;
  Offset lastOffset;

  await for (var event in events) {
    switch (event.runtimeType) {
      case TwoPointEventStart:
        startDistanceSq = (event.point1 - event.point2).distanceSquared;
        startPosition = (event.point1 + event.point2) / 2.0;
        lastPosition = startPosition;
        lastOffset = Offset(0.0, 0.0);
        lastScale = 1.0;
        yield ScaleEventStart();
        break;
      case TwoPointEventUpdate:
        lastScale = sqrt(
            (event.point1 - event.point2).distanceSquared / startDistanceSq);
        lastPosition = (event.point1 + event.point2) / 2.0;
        lastOffset = lastPosition - startPosition;
        yield ScaleEventUpdate(lastScale, lastOffset);
        break;
      case TwoPointEventEnd:
        yield ScaleEventEnd(lastScale, lastOffset);
        break;
    }
  }
}
