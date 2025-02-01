import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially_app/models/reel_model.dart';

class ReelServices {
  final CollectionReference _reelCollectionRef =
      FirebaseFirestore.instance.collection("reels");

  // save reel in Firestore
  Future<void> saveReel(Map<String, dynamic> reelDetails) async {
    try {
      final newReel = ReelModel(
        reelId: "",
        caption: reelDetails["caption"],
        videoUrl: reelDetails["videoUrl"],
        userId: reelDetails["userId"],
        userName: reelDetails["userName"],
        profileImageUrl: reelDetails["profileImageUrl"],
        dateOfPublished: DateTime.now(),
      );

      final DocumentReference ref =
          await _reelCollectionRef.add(newReel.toJson());

      await ref.update({"reelId": ref.id});
    } catch (err) {
      print("######################### Error saving reel $err");
    }
  }
}
