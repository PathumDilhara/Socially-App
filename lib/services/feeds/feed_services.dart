import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially_app/models/post_model.dart';
import 'package:socially_app/utils/functions/moods.dart';

import 'feed_storage.dart';

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

  // create a method to like a post
  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    final DocumentReference postLikeRef =
        _feedsCollection.doc(postId).collection("likes").doc(userId);

    try {
      // Add a document to the likes sub collection(don't need a model always)
      await postLikeRef.set({"LikedAt": Timestamp.now()});

      // update the likes count in the post document
      final DocumentSnapshot postDoc = await _feedsCollection.doc(postId).get();
      final PostModel post =
          PostModel.fromJson(postDoc.data() as Map<String, dynamic>);

      final int newNoOfLikes = post.noOfLikes + 1;
      // Update the doc
      await _feedsCollection.doc(postId).update({"noOfLikes": newNoOfLikes});
      print("######################### Post liked successfully");
    } catch (err) {
      print("Error like post : $err");
    }
  }

  // create a method to dis like a post
  Future<void> disLikePost({
    required String postId,
    required String userId,
  }) async {
    final DocumentReference postLikeRef =
        _feedsCollection.doc(postId).collection("likes").doc(userId);

    try {
      // delete the document from the likes sub collection
      await postLikeRef.delete();

      // update the likes count in the post document
      final DocumentSnapshot postDoc = await _feedsCollection.doc(postId).get();
      final PostModel post =
          PostModel.fromJson(postDoc.data() as Map<String, dynamic>);

      final int newNoOfLikes = post.noOfLikes - 1;
      // Update the doc
      await _feedsCollection.doc(postId).update({"noOfLikes": newNoOfLikes});
      print("######################### Post liked successfully");
    } catch (err) {
      print("Error like post : $err");
    }
  }

  // Check if the user liked a the post
  Future<bool> hasUserLikedPost({
    required String postId,
    required String userId,
  }) async {
    try {
      final DocumentReference postLikeRef =
          _feedsCollection.doc(postId).collection("likes").doc(userId);

      final DocumentSnapshot doc = await postLikeRef.get();
      print("################################@@@@@@@@@@@@@@@@@ ${doc.exists}");
      return doc.exists;
    } catch (err) {
      print(
          "############################# Error checking user liked or not $err");
      return false;
    }
  }

  // Delete a post from the firebase database
  Future<void> deletePost({
    required String postId,
    required String postUrl,
  }) async {
    try {
      // delete the image from cloud storage
      await FeedStorage().deletePostImage(imageUrl: postUrl);

      // Delete the firebase document
      await _feedsCollection.doc(postId).delete();
    } catch (err) {
      print("################### Error deleting pst from firestore $err");
    }
  }

  // get all posts images from the user
  Future<List<String>> getAllUsersPostImages({required String userId}) async {
    try {
      final userPosts = await _feedsCollection
          .where("userId", isEqualTo: userId)
          .get()
          .then((snapshot) {
        return snapshot.docs.map((doc) {
          return PostModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });

      return userPosts.map((post) => post.postURL).toList();
    } catch (err) {
      print("################ Error fetching all post images");
      return [];
    }
  }
}
