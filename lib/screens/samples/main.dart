import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodvocabularyapp/screens/ocr_explorer/main.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

final cacheDirFuture =
    (() async => (await (await getTemporaryDirectory()).createTemp()).path)();

class SamplesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: null,
      body: Container(
          child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Sample(image: AssetImage("samples/1.jpg")),
          Sample(image: AssetImage("samples/2.jpg")),
          Sample(image: AssetImage("samples/3.jpg")),
          Sample(image: AssetImage("samples/4.jpg")),
          Sample(image: AssetImage("samples/5.jpg")),
          Sample(image: AssetImage("samples/6.jpg")),
          Sample(image: AssetImage("samples/7.jpg")),
          Sample(image: AssetImage("samples/8.jpg")),
        ],
      )), //_body(),
    );
  }
}

class Sample extends StatelessWidget {
  const Sample({Key key, this.image}) : super(key: key);
  static bool _loading = false;

  final AssetImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: GestureDetector(
        onTap: () async {
          if (!Sample._loading) {
            Sample._loading = true;
            File f = await _getAssetAsFile(image.assetName);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PictureExplorer(image: f)));
            Sample._loading = false;
          }
        },
        child: Container(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover, image: image)),
            child: null,
          ),
        ),
      ),
    );
  }
}

Future<File> _getAssetAsFile(String assetName) async {
  final fileName = assetName.replaceAll('/', '_');
  final cacheDir = await cacheDirFuture;
  final file = File("$cacheDir/$fileName");
  if (await file.exists()) {
    return file;
  } else {
    final data = await rootBundle.load(assetName);
    await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
  return file;
}
