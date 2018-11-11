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
import 'package:twfoodtranslations/PannedView.dart';
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
  String _selectedText;

  setImage(File image) async {
    setState(() {
      _image = image;
      _selectedText = null;
      _result = ResultFuture(recognizeText(image.path));
      _result.whenComplete(() => setState(() {}));
    });
  }

  List<Widget> _recognizedTextOverlay(BoxConstraints constraints) {
    if (_result == null) {
      return [];
    } else if (_result.isComplete) {
      if (_result.result.isValue) {
        final result = _result.result.asValue.value;
        final ratio = constraints.maxWidth.toDouble() / result.imgWidth;
        return result.blocks
            .expand((block) => block.lines)
            .expand((line) => line.elements)
            .map((elm) {
          final Rectangle<int> bb = elm.boundingBox;
          final text = elm.text;

          return Positioned(
              left: bb.left.toDouble() * ratio,
              top: bb.top.toDouble() * ratio,
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      print('selected text: $text');
                      _selectedText = text;
                    });
                  },
                  child: Container(
                      width: bb.width.toDouble() * ratio,
                      height: bb.height.toDouble() * ratio,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: text == _selectedText
                                  ? Colors.redAccent
                                  : Colors.blueAccent)),
                      child: null)));
        }).toList();
      } else {
        return [
          Center(
              child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(_result.result.asError.error,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                  )))
        ];
      }
    } else {
      return [
        Center(
            child: Container(
                decoration: BoxDecoration(color: Colors.blueAccent),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Analyzing image...',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                )))
      ];
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
        ? Container(
            child: PannedView(
            key: Key('${_selectedText.hashCode} ${_image.hashCode}'),
            maxWidth: 1000.0,
            maxHeight: 1000.0,
            child: Container(
                width: 1000.0,
                height: 1000.0,
                child: LayoutBuilder(
                    builder: (context, constraints) => Stack(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                              Container(
                                child: _showImage(),
                              ),
                            ] +
                            _recognizedTextOverlay(constraints) +
                            [_selectedWidget()]
                        //     //     //+_recognizedTextOverlay()
                        ))),
          ))
        : Center(
            child: Text('No image selected'),
          );
  }

  Widget _showImage() {
    return _image == null ? Text('No image selected!') : Image.file(_image);
  }

  Widget _selectedWidget() {
    return _selectedText == null
        ? Container(
            width: 0.0,
            height: 0.0,
            child: null,
          )
        : Positioned(
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blueAccent)),
              child: Text(_selectedText),
            ),
          );
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
