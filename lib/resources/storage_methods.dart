import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer' as devtools show log;

import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
    String childName,
    Uint8List? fileData,
    bool isPost,
  ) async {
    String downloadUrl = '';
    if (fileData != null) {
      Reference ref =
          _storage.ref().child(childName).child(_auth.currentUser!.uid);

      if (isPost) {
        String id = const Uuid().v1();
        ref.child(id);
      }

      UploadTask uploadTask = ref.putData(fileData);

      TaskSnapshot snap = await uploadTask;

      downloadUrl = await snap.ref.getDownloadURL();
      devtools.log('Upload image  successfully');
    }

    return downloadUrl;
  }
}
