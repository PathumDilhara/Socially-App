import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/functions/moods.dart';

class PostModel {
  final String postId;
  final String postCaption;
  final Mood mood;
  final String userId;
  final String userName;
  final String profileImage;
  final int noOfLikes;
  final DateTime dateOfPublish;
  final String postURL;

  PostModel({
    required this.postId,
    required this.postCaption,
    required this.mood,
    required this.userId,
    required this.userName,
    required this.profileImage,
    required this.noOfLikes,
    required this.dateOfPublish,
    required this.postURL,
  });

  // Convert a post instance to a map (for saving to Firebase) / Dart to json
  Map<String, dynamic> toJson() {
    return {
      "postId": postId,
      "postCaption": postCaption,
      "mood": mood.name,
      "userId": userId,
      "userName": userName,
      "noOfLikes": noOfLikes,
      "profileImage": profileImage,
      "dateOfPublish": Timestamp.fromDate(dateOfPublish),
      "postURL": postURL,
    };
  }

  // create a post instance from a map (for retrieving from Firebase)
  factory PostModel.fromJson(Map<String, dynamic> data) {
    return PostModel(
      postId: data["postId"] ?? "",
      postCaption: data["postCaption"] ?? "",
      mood: MoodsExtension.formString(data["mood"] ?? "happy"),
      userId: data["userId"] ?? "",
      userName: data["userName"] ?? "",
      profileImage: data["profileImage"] ?? "",
      noOfLikes: data["noOfLikes"] ?? 0,
      dateOfPublish: (data["dateOfPublish"] as Timestamp).toDate(),
      postURL: data["postURL"] ?? "",
    );
  }
}
