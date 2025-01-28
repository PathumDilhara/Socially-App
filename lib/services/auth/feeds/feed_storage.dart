import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

// To store image file in cloud
class FeedStorage {
  // Firebase storage instance
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Upload an image
  Future<String> uploadImage({required File postImage, required String userId}) async {
    // Storage reference
    final Reference ref = _firebaseStorage
        .ref()
        .child("feed-images") // parent folder
        .child("$userId/${DateTime.now()}"); // subfolder

    try {
      final UploadTask task = ref.putFile(
        postImage,
        SettableMetadata(contentType: "image/jpeg"),
      );

      TaskSnapshot snapshot = await task;
      final String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (err) {
      print("################################### ${err.toString()}");
      return "";
    }
  }
}
