import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:foodvocabularyapp/NoSelection.dart';
import 'package:foodvocabularyapp/RecognizedTextOverlay.dart';
import 'package:foodvocabularyapp/RecognizedTextPainter.dart';
import 'package:foodvocabularyapp/SelectedTextBar.dart';
import 'package:foodvocabularyapp/TermBlock.dart';
import 'package:foodvocabularyapp/TouchHighlight.dart';
import 'package:foodvocabularyapp/ImagePickerDialog.dart';
import 'package:foodvocabularyapp/ZoomView.dart';
import 'package:foodvocabularyapp/dictionary.dart';
import 'package:foodvocabularyapp/utils/text_recognition.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ResultFuture<RecognizedText> _result;
  File _image;
  List<NormalizedTextBlock> _selectedBlocks = List();
  final _dictionary = ResultFuture(loadDictionary());

  double _currentScale = 1.0;

  setImage(File image) async {
    setState(() {
      _image = image;
      _result = ResultFuture(recognizeText(image.path));
      _result.whenComplete(() => setState(() {}));
      _selectedBlocks = List();
    });
  }

  _onTextElementSelect(NormalizedTextBlock elm) {
    setState(() {
      _selectedBlocks.add(elm);
    });
  }

  Widget _recognizedTextOverlay() {
    return RecognizedTextOverlay(
      visionResult: _result.result.asValue.value,
      selectedBlocks: _selectedBlocks,
      onSelect: _onTextElementSelect,
    );
  }

  Widget _showWaiting() {
    if (_result.isComplete) {
      if (_result.result.isValue) {
        assert(false);
      } else {
        return Center(
            child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(_result.result.asError.error.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent)),
                )));
      }
    }
    return Center(
        child: Container(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Analyzing image...',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            )));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: null,
      body: _body(), //_body(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          ImagePickerDialog.show(context: context, onImagePick: setImage);
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _body() {
    return _image != null
        ? Stack(
            children: _result.isComplete &&
                    _result.result.isValue &&
                    _dictionary.isComplete &&
                    _dictionary.result.isValue
                ? [
                    ZoomView(
                        key: Key(_image.path),
                        centerAt: _centerAt,
                        onScaleUpdate: (scale) {
                          _currentScale = scale;
                        },
                        child: Container(child: _showResult())),
                    _selectionWidget()
                  ]
                : [_showWaiting()])
        : Center(
            child: Text('No image selected'),
          );
  }

  double _getStrokeWidth() {
    return 20.0 / _currentScale;
  }

  Widget _showResult() {
    assert(_image != null);
    assert(_result.isComplete);
    assert(_result.result.isValue);
    return FittedBox(
        fit: BoxFit.scaleDown,
        child: TouchHighlight(
          getStrokeWidth: _getStrokeWidth,
          child: CustomPaint(
              foregroundPainter: RecognizedTextOverlayPainter(
                  _result.result.asValue.value, _selectedBlocks),
              child: Image.file(_result.result.asValue.value.image)),
          onHighlightMove: onHightlightMove,
          onHighlightReset: onHighlightReset,
          onHighlightEnd: onHighlightEnd,
        ));
  }

  Widget _selectionWidget() {
    return Positioned(
      bottom: 0.0,
      child: LayoutBuilder(
          builder: (context, constraints) => Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.black, blurRadius: 20)
                  ]),
                  child: Container(
                    color: Colors.white,
                    child: _highlightIsMoving || _selectedBlocks.length == 0
                        ? NoSelection()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                SelectedTextBar(
                                    _selectedBlocks
                                        .map((block) => block.text)
                                        .join(""),
                                    onRemoveClick: removeLastSelection),
                                translations()
                              ]),
                  ),
                ),
              )),
    );
  }

  removeLastSelection() {
    setState(() {
      _selectedBlocks = List();
    });
  }

  Widget translations() {
    String query = _selectedBlocks.map((block) => block.text).join('');
    List<Term> terms = _dictionary.result.asValue.value.search(query);
    if (terms.length == 0) {
      return Padding(
          padding: EdgeInsets.all(50),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Text('Translation not available for:'),
                Text(
                  _selectedBlocks.map((block) => block.text).join(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ])));
    }
    return Container(
        height: 350.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: terms.length,
            itemBuilder: (context, i) {
              final t = terms[i];
              return Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                child: TermBlock(t, query, _dictionary.result.asValue.value),
              );
            }));
  }

  Offset _lastMove;
  bool _highlightIsMoving = false;
  void onHightlightMove(Offset position, double radius) {
    if (!_highlightIsMoving) {
      setState(() {
        _highlightIsMoving = true;
      });
    }
    if (_lastMove == null ||
        (_lastMove - position).distanceSquared > (radius * radius / 4)) {
      _lastMove = position;
      for (var obj
          in _result.result.asValue.value.findInRadius(position, radius / 2)) {
        if (!_selectedBlocks.contains(obj)) {
          setState(() {
            _selectedBlocks.add(obj);
          });
        }
      }
    }
  }

  void onHighlightReset() {
    setState(() {
      _selectedBlocks.clear();
      _highlightIsMoving = false;
      _lastMove = null;
    });
  }

  Offset _centerAt;
  void onHighlightEnd() {
    setState(() {
      if (_lastMove != null) {
        _centerAt = _lastMove;
      }
      _highlightIsMoving = false;
      _lastMove = null;
      if (_selectedBlocks.length > 0) {
        final text =
            _selectedBlocks.map((block) => block.text).toList().join(' ');
        final data = {"text": text};
        http.post("https://skijur.com/highlighted-text-log",
            headers: {"content-type": "application/json"},
            body: jsonEncode(data),
            encoding: Utf8Codec());
      }
    });
  }
}
