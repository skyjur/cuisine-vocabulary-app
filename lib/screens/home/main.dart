import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodvocabularyapp/screens/ocr_explorer/main.dart';
import 'package:foodvocabularyapp/screens/samples/main.dart';
import 'package:foodvocabularyapp/ui/icon_tile_button.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Container(
            alignment: AlignmentDirectional.bottomEnd,
            child: SizedBox(
              height: constraints.maxWidth / 3.0,
              width: constraints.maxWidth,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconTileButton(
                        size: constraints.maxWidth / 3.0,
                        label: "Take\nphoto",
                        icon: Icons.photo_camera,
                        onTap: () {
                          _getImage(context, ImageSource.camera);
                        }),
                    IconTileButton(
                        size: constraints.maxWidth / 3.0,
                        label: 'Open\nfrom gallery',
                        icon: Icons.photo_library,
                        onTap: () {
                          _getImage(context, ImageSource.gallery);
                        }),
                    IconTileButton(
                        size: constraints.maxWidth / 3.0,
                        label: 'Explore\nsamples',
                        icon: Icons.view_module,
                        onTap: () {
                          _exploreSamples(context);
                        }),
                  ]),
            ),
          )),
    );
  }

  Future _getImage(BuildContext context, ImageSource source) async {
    File img = await ImagePicker.pickImage(source: source);
    if (img != null) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PictureExplorer(image: img)));
    }
  }

  void _exploreSamples(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SamplesScreen()));
  }
}
