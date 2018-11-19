import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:twfoodtranslations/ImagePickerDialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:twfoodtranslations/PannedView.dart';
import 'package:twfoodtranslations/dictionary.dart';
import 'package:twfoodtranslations/dictionaryMatcher.dart';
import 'package:twfoodtranslations/dictionarySearch.dart';
import 'package:twfoodtranslations/utils/text_recognition.dart';
import 'package:photo_view/photo_view.dart';

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
  ResultFuture<VisionResult> _result;
  File _image;
  Set<TextBlock> _selectedBlocks = Set();
  final index = DictionaryIndex(Dictionary);

  setImage(File image) async {
    setState(() {
      _image = image;
      _result = ResultFuture(recognizeText(image.path));
      _result.whenComplete(() => setState(() {}));
      _selectedBlocks = Set();
    });
  }

  Widget _recognizedTextOverlay(BoxConstraints constraints) {
    if (_result == null) {
      return Container(width: 0.0, height: 0.0, child: null);
    } else if (_result.isComplete) {
      if (_result.result.isValue) {
        final visionText = _result.result.asValue.value;
        final ratio = constraints.maxWidth.toDouble() / visionText.imgWidth;
        final processedResult = dictionaryMatcher(visionText);
        return Stack(
            children: processedResult.map((elm) {
          final text = elm.text;

          return Positioned(
              left: elm.left.toDouble() * ratio,
              top: elm.top.toDouble() * ratio,
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedBlocks.contains(elm)) {
                        _selectedBlocks.remove(elm);
                      } else {
                        _selectedBlocks.add(elm);
                      }
                      print('selected text: $text');
                    });
                  },
                  child: Container(
                      width: (elm.right - elm.left).toDouble() * ratio,
                      height: (elm.bottom - elm.top).toDouble() * ratio,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: _selectedBlocks.contains(elm)
                                  ? Colors.redAccent
                                  : elm.termMatch.length > 0
                                      ? Colors.greenAccent
                                      : Colors.blueAccent)),
                      child: null)));
        }).toList());
      } else {
        return Center(
            child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(_result.result.asError.error,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent)),
                )));
      }
    } else {
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
        ? Stack(children: <Widget>[
            PannedView(
              key: Key(_image.path),
              child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                  child: LayoutBuilder(
                      builder: (context, constraints) => Stack(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                OverflowBox(
                                    alignment: Alignment.topCenter,
                                    maxHeight: double.infinity,
                                    child: _showImage()),
                                _recognizedTextOverlay(constraints)
                              ]
                              //     //     //+_recognizedTextOverlay()
                              ))),
            ),
            _selectionWidget(),
          ])
        : Center(
            child: Text('No image selected'),
          );
  }

  Widget _showImage() {
    return _image == null
        ? Text('No image selected!')
        : Container(
            decoration: BoxDecoration(
                border: Border.all(width: 3.0, color: Colors.black)),
            child: Image.file(_image));
  }

  Widget _selectionWidget() {
    return _selectedBlocks.length == 0
        ? Container(
            width: 0.0,
            height: 0.0,
            child: null,
          )
        : Positioned(
            bottom: 0.0,
            child: LayoutBuilder(
                builder: (context, constraints) => Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.blueAccent)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(
                                _selectedBlocks.map((elm) => elm.text).join(''),
                                style: TextStyle(fontSize: 25.0),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                      onTap: () => setState(() =>
                                          _selectedBlocks
                                              .remove(_selectedBlocks.last)),
                                      child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              15.0, 5.0, 15.0, 5.0),
                                          child: Icon(
                                            Icons.backspace,
                                            size: 30.0,
                                            color: Colors.redAccent,
                                          ))),
                                ),
                              )
                            ]),
                            translations()
                          ]),
                    )),
          );
  }

  Widget translations() {
    String query = _selectedBlocks.map((block) => block.text).join('');
    List<Term> terms = index.search(query);
    if (terms.length == 0) {
      return Container(
          height: 200.0,
          child: Center(
            child: Text('Sorry no dictionary matches found'),
          ));
    }
    return Container(
        height: 300.0,
        child: ListView(
            children: terms
                .map((t) => Row(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                        child: Image.asset(
                          t.imagePath,
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _highlight(t.term, query),
                          Text('${t.pinYin}'),
                          Text('${t.translation}'),
                        ],
                      ))
                    ]))
                .toList()));
  }

  _highlight(String text, String query) {
    return RichText(
        text: TextSpan(
            children: text.split('').map((t) {
      if (query.contains(t)) {
        return TextSpan(
            text: t, style: TextStyle(fontSize: 25.0, color: Colors.black));
      } else {
        return TextSpan(
            text: t, style: TextStyle(color: Colors.black45, fontSize: 25.0));
      }
    }).toList()));
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
