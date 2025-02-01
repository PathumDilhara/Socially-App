import 'package:cloud_firestore/cloud_firestore.dart';

class ReelModel {
  final String reelId;
  final String caption;
  final String videoUrl;
  final String userId;
  final String userName;
  final String profileImageUrl;
  final DateTime dateOfPublished;

  ReelModel({
    required this.reelId,
    required this.caption,
    required this.videoUrl,
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.dateOfPublished,
  });

  // Convert reel instance to a map (for saving to firestore)
  Map<String, dynamic> toJson() {
    return {
      "reelId": reelId,
      "caption": caption,
      "videoUrl": videoUrl,
      "userId": userId,
      "userName": userName,
      "profileImageUrl": profileImageUrl,
      "dateOfPublished": dateOfPublished,
    };
  }

  // Create a reel instance from a map (for retrieving from firestore)
  factory ReelModel.fromJson(Map<String, dynamic> data) {
    return ReelModel(
      reelId: data["reelId"] ?? "",
      caption: data["caption"] ?? "",
      videoUrl: data["videoUrl"] ?? "",
      userId: data["userId"] ?? "",
      userName: data["userName"] ?? "",
      profileImageUrl: data["profileImageUrl"] ?? "",
      dateOfPublished: (data["dateOfPublished"] as Timestamp).toDate(),
    );
  }
}
