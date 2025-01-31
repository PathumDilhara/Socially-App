import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially_app/models/post_model.dart';
import 'package:socially_app/services/auth/feeds/feed_storage.dart';
import 'package:socially_app/utils/functions/moods.dart';

class FeedServices {
  final CollectionReference _feedsCollection =
      FirebaseFirestore.instance.collection("feeds");

  // Save the post in the Firestore db
  Future<void> savePost(Map<String, dynamic> postDetails) async {
    try {
      String? postCloudStorageUrl;

      if (postDetails["postImage"] != null &&
          postDetails["postImage"] is File) {
        postCloudStorageUrl = await FeedStorage().uploadImage(
          postImage: postDetails["postImage"] as File,
          userId: postDetails["userId"] as String,
        );
      }

      // Create a new post obj
      final PostModel newPost = PostModel(
        postId: "",
        postCaption: postDetails["postCaption"] as String? ?? "",
        mood: MoodsExtension.formString(postDetails["mood"] ?? "happy"),
        userId: postDetails["userId"] as String? ?? "",
        userName: postDetails["userName"] as String? ?? "",
        profileImage: postDetails["profileImage"] as String? ?? "",
        noOfLikes: 0,
        dateOfPublish: DateTime.now(),
        postURL: postCloudStorageUrl ?? "",
      );

      // Add the post to the collection
      await _feedsCollection
          .add(newPost.toJson())
          .then((docRef) => docRef.update({"postId": docRef.id}));

      print("#################### post saved");
    } catch (err) {
      print("Error saving post : $err");
    }
  }

  // fetch the post as a stream
  Stream<List<PostModel>> getPostStream() {
    return _feedsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
