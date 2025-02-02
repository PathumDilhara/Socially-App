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
}
