import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(PickedFile imageFile) async {
    String filename = basename(imageFile.path);

    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('/user').child(filename);

    firebase_storage.UploadTask task = ref.putFile(io.File(imageFile.path));

    firebase_storage.TaskSnapshot uploadedFile = await task;

    String downloadUrl = "";

    if (uploadedFile.state == firebase_storage.TaskState.success) {
      downloadUrl = await ref.getDownloadURL();
    }

    return downloadUrl;
  }

  Future<String> getUrlImage(String img) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('$img')
        .getDownloadURL();

    return downloadURL;
  }
}

final storage = Storage();
