// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:twfoodtranslations/utils/text_recognition.dart';

class RecognizedTextOverlay extends StatelessWidget {
  RecognizedTextOverlay(
      {Key key, this.visionResult, this.selectedBlocks, this.onSelect})
      : super(key: key);

  final RecognizedText visionResult;
  final Iterable<NormalizedTextBlock> selectedBlocks;
  final void Function(NormalizedTextBlock text) onSelect;

  Widget build(BuildContext context) {
    return Stack(
        children: visionResult.blocks.map((elm) {
      return Positioned(
          left: elm.left,
          top: elm.top,
          child: RecognizedTextBox(
              elm: elm,
              selected: selectedBlocks.contains(elm),
              onSelect: onSelect));
    }).toList());
  }
}

class RecognizedTextBox extends StatelessWidget {
  RecognizedTextBox({Key key, this.elm, this.selected, this.onSelect})
      : super(key: key);

  final NormalizedTextBlock elm;
  final bool selected;
  final void Function(NormalizedTextBlock elm) onSelect;

  build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onSelect(elm);
        },
        child: Container(
            width: elm.right - elm.left,
            height: elm.bottom - elm.top,
            child: null,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2.0,
                    color: this.selected
                        ? Color.fromRGBO(200, 100, 100, 0.5)
                        : Color.fromRGBO(255, 255, 255, 0.5)))));
  }
}
