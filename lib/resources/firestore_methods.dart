import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_flutter/models/post.dart' as model;
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List fileData,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = 'Some error occurred when uploading post';
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        'posts',
        fileData,
        true,
      );

      String postId = const Uuid().v1();
      model.Post post = model.Post(
        description: description,
        username: username,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<String> postComment(
    String postId,
    String uid,
    String text,
    String name,
    String profilePic,
  ) async {
    String res = 'Some error occurred when posting this comment';
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = 'Text is empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
