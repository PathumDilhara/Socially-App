import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socially_app/models/user_model.dart';
import 'package:socially_app/widgets/custom_snackbar.dart';

import '../exceptions/exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

// Sign in anonymously

  // Sign out
  //This methode will sign out the user and print a message to the console
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
    } on FirebaseAuthException catch (e) {
      print('Error signing out: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Get the current user
  //This methode will return the current user , here the user is the one that is signed in and fierbase will return the user and we can use it to get the user data (uid, email...)
  User? getCurrentUser() {
    return _auth.currentUser;
  }

//create user with email and password
  //This methode will create a new user with email and password and return the user credential
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error creating user: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error creating user: $e');
      throw Exception(e.toString());
    }
  }

  //sign/log in with email and password
  //This methode will sign in the user with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required dynamic context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("########################## User sign in successfully");
    } on FirebaseAuthException catch (e) {
      print(
          '##################### Error signing in: ${mapFirebaseAuthExceptionCode(e.code)}');
      customSnackBar(
        content: "Error signing in check again email and password",
        color: Colors.redAccent,
        context: context,
      );
      // gs://
      // socially-app-5b697.firebasestorage.app

      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('############################# Error signing in: $e');

      customSnackBar(
        content: "Error signing in check again email and password",
        color: Colors.redAccent,
        context: context,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // if null simply return/exit
      if (googleUser == null) {
        return;
      }

      // if not null get user details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // create new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // sign in to firebase with the google auth credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // get the user
      final User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          userId: user.uid,
          name: user.displayName ?? "No name",
          email: user.email ?? "No email",
          jobTitle: "jobTitle",
          imageUrl: user.photoURL ?? "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          password: "", // handle by google acc
          noOfFollowers: 0,
        );

        // Save user to firestore
        final DocumentReference reference =
            FirebaseFirestore.instance.collection("users").doc(user.uid);

        await reference.set(newUser.toJson());
        
        print("User data saved in firestore successfully under google sign in");
      }
    } on FirebaseAuthException catch (err) {
      throw Exception(mapFirebaseAuthExceptionCode(err.code));
    } catch (err) {
      print("############################### Error : $err");
    }
  }
}
