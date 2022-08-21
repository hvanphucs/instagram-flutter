import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String? username;
  final String uid;
  final String? postId;
  final DateTime? datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  const Post({
    required this.description,
    required this.username,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'description': description,
        'username': username,
        'uid': uid,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes,
      };

  static Post fromSnapshot(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      postId: snapshot['postId'],
      description: snapshot['description'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['photoUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
