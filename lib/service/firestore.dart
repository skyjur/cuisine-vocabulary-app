import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

StorageUploadTask uploadToFirestore(File fileToUpload) {
  final uuid = Uuid().v1();
  final ref = FirebaseStorage.instance
      .ref()
      .child('public')
      .child('uploads')
      .child(uuid);
  // print('Ref: ' + ref.path);
  return ref.putFile(fileToUpload);
}
