import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';
import '../auth/auth_services.dart';

class UserService {
  // Create a collection reference
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // final CollectionReference _feedCollection =
  //     FirebaseFirestore.instance.collection('feed');

  // Save the user in the Firestore database
  Future<void> saveUser(UserModel user) async {
    try {
      // Create a new user with email and password
      final userCredential = await AuthService().createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      print("################################### ${userCredential.user}");
      print("################################### ${userCredential.user!.uid}");

      // Retrieve the user ID from the created user
      final userId = userCredential.user?.uid;

      if (userId != null) {
        // Create a new user document in Firestore with the user ID as the document ID
        final userRef = _usersCollection.doc(userId);

        // Create a user map with the userId field
        final userMap = user.toJson();
        userMap['userId'] = userId;

        // Set the user data in Firestore
        await userRef.set(userMap);

        print('User saved successfully with ID: $userId');
      } else {
        print('Error: User ID is null');
      }
    } catch (error) {
      print('Error saving user: $error');
    }
  }

  // get user details by id
  Future<UserModel?> getUserDetailsById({required String userId}) async {
    try {
      final DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      print("################################ doc ${doc.id}, $userId");

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (err) {
      print(
          "################################# getUserDetailsById ${err.toString()}");
      return null;
    }
    return null;
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final QuerySnapshot snapshot = await _usersCollection.get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (err) {
      print("################## Error getting all users $err");
      return [];
    }
  }

  // Method follow user & update the user followers counter
  Future<void> followUser({
    required String currentUserId,
    required String userToFollowId,
  }) async {
    try {
      await _usersCollection
          .doc(userToFollowId)
          .collection("followers")
          .doc(currentUserId)
          .set({"FollowedAt": Timestamp.now()});

      // update following count for the followed user
      final followedUserRef = _usersCollection.doc(userToFollowId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final followedUserDoc = await transaction.get(followedUserRef);

        if (followedUserDoc.exists) {
          final data = followedUserDoc.data() as Map<String, dynamic>;
          final currentFollowersCount = data['followersCount'] ?? 0;
          transaction.update(
              followedUserRef, {"followersCount": currentFollowersCount + 1});
        }
      });

      // update the following count for the current user
      final currentUserRef = _usersCollection.doc(currentUserId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final currentUserDoc = await transaction.get(currentUserRef);

        if (currentUserDoc.exists) {
          final data = currentUserDoc.data() as Map<String, dynamic>;
          final currentFollowingCount = data['followingCount'] ?? 0;
          transaction.update(
              currentUserRef, {"followingCount": currentFollowingCount + 1});
        }
      });

      print('"####################### User successfully follow');
    } catch (err) {
      print("############################### Error following user $err");
    }
  }

  // Method to unfollow user & update the user followers count
  Future<void> unfollowUser({
    required String currentUserId,
    required String userToUnfollowId,
  }) async {
    try {
      // remove the user from the followers collection
      await _usersCollection
          .doc(userToUnfollowId)
          .collection("followers")
          .doc(currentUserId)
          .delete();

      // Update the followers count for the unfollowed user
      final unfollowedUserRef = _usersCollection.doc(userToUnfollowId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final unfollowedUserDoc = await transaction.get(unfollowedUserRef);

        if (unfollowedUserDoc.exists) {
          final data = unfollowedUserDoc.data() as Map<String, dynamic>;

          final currentCount = data["followersCount"] ?? 0;
          transaction
              .update(unfollowedUserRef, {"followersCount": currentCount - 1});
        }
      });

      // update following count for the current user
      final currentUserRef = _usersCollection.doc(currentUserId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final currentUserDoc = await transaction.get(currentUserRef);

        if (currentUserDoc.exists) {
          final data = currentUserDoc.data() as Map<String, dynamic>;

          final currentCount = data["followingCount"] ?? 0;
          transaction
              .update(unfollowedUserRef, {"followingCount": currentCount - 1});
        }
      });

      print("################# User unfollowed successfully");
    } catch (err) {
      print("############################# Failed to unfollow $err");
    }
  }

  // Method to check if the current user is following another user
  Future<bool> isFollowing({
    required String currentUserId,
    required String userToCheckId,
  }) async {
    try {
      final docSnapshot = await _usersCollection
          .doc(userToCheckId)
          .collection("followers")
          .doc(currentUserId)
          .get();

      return docSnapshot.exists;
    } catch (err) {
      print("################### Error checking user following or not $err");
      return false;
    }
  }

  // get the count of followers for a user
  Future<int> getUserFollowersCount (String userId)async{
      try{
        final doc = await _usersCollection.doc(userId).get();

        if(doc.exists){
          final data = doc.data() as Map<String, dynamic>;
          return data["followersCount"] ?? 0;
        }
        return 0;
      } catch(err) {
        print("############## Error getting user followers count $err");
        return 0;
      }
  }

  // get the count of following for a user
  Future<int> getUserFollowingCount (String userId)async{
    try{
      final doc = await _usersCollection.doc(userId).get();

      if(doc.exists){
        final data = doc.data() as Map<String, dynamic>;
        return data["followingCount"] ?? 0;
      }
      return 0;
    } catch(err) {
      print("############## Error getting user following count $err");
      return 0;
    }
  }
}
