import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //
  Future<model.User> getUserDetails() async {
    User? currentUser = _auth.currentUser;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser?.uid).get();

    return model.User.fromSnapshot(snap);
  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred when creating your account';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // register user
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String? photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        // add user to our database

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = 'success';
      } else if (email.isEmpty) {
        res = 'Please enter the required email fields.';
      } else if (password.isEmpty) {
        res = 'Please enter the required password fields';
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          res = 'The email is badly formatted.';
          break;
        case 'email-already-in-use':
          res = 'The email address is already in use by another account.';
          break;
        case 'weak-password':
          res = 'Password must be at least 6 characters.';
          break;
        case 'unknown':
          res = 'Please enter the required fields.';
          break;
        default:
          res = e.toString();
      }
    } catch (e) {
      res = e.toString();
    }

    devtools.log(res);
    return res;
  }

  // Login
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred when logging';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter all required fields';
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          res = 'Email provided not found.';
          break;
        case 'wrong-password':
          res = 'The password is invalid.';
          break;
        default:
          res = e.toString();
      }
    } catch (e) {
      res = e.toString();
    }
    devtools.log(res);
    return res;
  }

  Future<void> signOut() async {
    _auth.signOut();
  }
}
