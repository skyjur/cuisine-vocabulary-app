import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef ImageSelectionCallback = void Function(File image);

class ImagePickerDialog extends StatelessWidget {
  ImagePickerDialog({Key key, @required this.onImagePick}) : super(key: key);

  final onImagePick;

  build(context) {
    return SimpleDialog(title: Text('Pick photo from:'), children: <Widget>[
      FlatButton(
          child: Text('Camera'),
          onPressed: () {
            _getImage(ImageSource.camera);
            Navigator.pop(context);
          }),
      FlatButton(
          child: Text('Gallery'),
          onPressed: () {
            _getImage(ImageSource.gallery);
            Navigator.pop(context);
          }),
    ]);
  }

  Future _getImage(ImageSource source) async {
    onImagePick(await ImagePicker.pickImage(source: source));
  }

  static show(
      {@required BuildContext context,
      @required ImageSelectionCallback onImagePick}) {
    showDialog(
        context: context,
        builder: (context) => ImagePickerDialog(onImagePick: onImagePick));
  }
}
