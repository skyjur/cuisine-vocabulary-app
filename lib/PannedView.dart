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
  PannedView({Key key, this.maxHeight, this.maxWidth, this.child})
      : super(key: key);

  final double maxWidth;
  final double maxHeight;
  final Widget child;

  @override
  _PannedView createState() => _PannedView(
      maxWidth: this.maxWidth, maxHeight: this.maxHeight, child: this.child);
}

class _PannedView extends State<PannedView> {
  _PannedView({this.maxWidth, this.maxHeight, this.child});

  final Widget child;
  final double maxWidth;
  final double maxHeight;
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  double _scale = 1.0;
  double _cursorX = 0.0;
  double _cursorY = 0.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onScaleStart: (pos) {
          _cursorX = pos.focalPoint.dx;
          _cursorY = pos.focalPoint.dy;
        },
        onScaleUpdate: (update) {
          setState(() {
            // _offsetX -= _cursorX - update.focalPoint.dx;
            // _offsetY -= _cursorY - update.focalPoint.dy;
            // print('x: $_offsetX y: $_offsetY');
            _scale = update.scale;
            print(
                'scale $_scale ${update.focalPoint.dx} ${update.focalPoint.dy} ${update}');
          });
        },
        child: Transform(
            transform: new Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
            alignment: FractionalOffset.center,
            child: child
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
