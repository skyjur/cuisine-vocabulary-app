import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:twfoodtranslations/ImagePickerDialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:twfoodtranslations/utils/text_recognition.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vector_math/vector_math_64.dart';

class PannedView extends StatefulWidget {
  PannedView({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _PannedView createState() => _PannedView();
}

class _PannedView extends State<PannedView> {
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  double _offsetStartX = 0.0;
  double _offsetStartY = 0.0;
  double _scale = 1.0;
  double _scaleStart = 1.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onScaleStart: (pos) {
          _offsetStartX = _offsetX - pos.focalPoint.dx;
          _offsetStartY = _offsetY - pos.focalPoint.dy;
          _scaleStart = _scale;
        },
        onScaleUpdate: (update) {
          setState(() {
            // _offsetX -= _cursorX - update.focalPoint.dx;
            // _offsetY -= _cursorY - update.focalPoint.dy;
            // print('x: $_offsetX y: $_offsetY');
            _scale = _scaleStart * update.scale;
            _offsetX = _offsetStartX + (update.focalPoint.dx);
            _offsetY = _offsetStartY + (update.focalPoint.dy);
            print(
                'scale $_scale ${update.focalPoint.dx} ${update.focalPoint.dy} $update');
          });
        },
        child: Transform(
            transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale))
              ..translate(_offsetX / _scale, _offsetY / _scale),
            alignment: FractionalOffset.center,
            child: this.widget.child
            // child: Stack(
            //   children: <Widget>[
            //     Positioned(
            //       top: _offsetY,
            //       left: _offsetX,
            //       child: Container(
            //         child: child,
            //       ),
            //     )
            //   ],
            // ),
            ));
  }
}
