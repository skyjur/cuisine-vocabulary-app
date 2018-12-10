import 'dart:math';

import 'package:flutter/material.dart';
import 'package:twfoodtranslations/TwoPointScaleRecognizer.dart';
import 'package:vector_math/vector_math_64.dart';

typedef Widget ScaledChildBuilder(double scale);

class ZoomView extends StatefulWidget {
  ZoomView({Key key, this.child, this.onScaleUpdate, this.centerAt})
      : super(key: key);

  final Widget child;
  final void Function(double scale) onScaleUpdate;
  final Offset centerAt;

  @override
  _ZoomView createState() {
    onScaleUpdate(1.0);
    return _ZoomView();
  }
}

class _ZoomView extends State<ZoomView> {
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  double _offsetStartX = 0.0;
  double _offsetStartY = 0.0;
  double _scale = 1.0;
  double _scaleStart = 1.0;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
        gestures: {
          TwoPointScaleRecognizer: TwoPointScaleRecognizer.getFactory(
              onStart: _onScaleStart,
              onUpdate: _onScaleUpdate,
              onEnd: _onScaleEnd)
        },
        child: SizedBox.expand(
            child: Transform(
                transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale))
                  ..translate(_offsetX / _scale, _offsetY / _scale),
                //alignment: FractionalOffset.topLeft,
                child: widget.child)));
  }

  void _onScaleStart(ScaleEventStart event) {
    _scaleStart = _scale;
    _offsetStartX = _offsetX;
    _offsetStartY = _offsetY;
  }

  void _onScaleUpdate(ScaleEventUpdate event) {
    setState(() {
      _scale = min(max(_scaleStart * event.scale, 0.75), 2.0);
      _offsetX = _offsetStartX + event.offset.dx;
      _offsetY = _offsetStartY + event.offset.dy;
    });
  }

  void _onScaleEnd(ScaleEventEnd event) {
    widget.onScaleUpdate(_scale);
  }
}
