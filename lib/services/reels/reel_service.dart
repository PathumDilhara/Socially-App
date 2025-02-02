import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially_app/models/reel_model.dart';
import 'package:socially_app/services/reels/reel_storage_service.dart';

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

  // fetch reels from firestore
  Stream<QuerySnapshot> getReels() {
    return _reelCollectionRef.snapshots();
  }

  // Delete reel from firestore
  Future<void> deleteReel({required ReelModel reel})async{
    try{
      await ReelStorageService().deleteVideo(videoUrl: reel.videoUrl);
      await _reelCollectionRef.doc(reel.reelId).delete();
    } catch(err){
      print("##################################### ${err.toString()}");
    }
  }
}
