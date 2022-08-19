import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer' as devtools show log;

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> uploadImageToStorage(
    String childName,
    Uint8List? fileData,
    bool isPost,
  ) async {
    String? downloadUrl;
    if (fileData != null) {
      Reference ref =
          _storage.ref().child(childName).child(_auth.currentUser!.uid);
      UploadTask uploadTask = ref.putData(fileData);

      TaskSnapshot snap = await uploadTask;

      downloadUrl = await snap.ref.getDownloadURL();
      devtools.log('Upload image user profile successfully');
    }

    return downloadUrl;
  }
}
