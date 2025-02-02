import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ReelStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // upload video to firestore storage
  Future<String> uploadVideo({
    required File videoFile,
    required String userId,
  }) async {
    try {
      // Generate a unique file name
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.mp4";

      // Create a reference to the video file in firestore storage
      final Reference ref = _firebaseStorage.ref().child("reels").child("$userId/$fileName");

      // upload the file to firebase storage
      await ref.putFile(videoFile);

      // get the downloadable url for the uploaded file
     final String url =  await ref.getDownloadURL();
     return url;
    } catch (err) {
      print("########################## Error uploading video $err");
      return "";
    }
  }

  // Delete video from firebase storage
  Future<void> deleteVideo({required String videoUrl}) async{
    try{
      // create reference to the  video file in firebase storage
      final Reference ref = _firebaseStorage.refFromURL(videoUrl);
      await ref.delete();
    }catch(err){
      print("################################# Error deleting video from storage $err");
    }
  }
}
