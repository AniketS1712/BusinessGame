import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "631482665751-52p7e5vbusp3u2ebnnj2um1s29r4klqn.apps.googleusercontent.com",
    );
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": user.displayName ?? "Unknown",
          "email": user.email,
          "profilePic": user.photoURL ?? "",
          "totalGamesPlayed": 0,
          "totalGamesWon": 0,
          "createdAt": FieldValue.serverTimestamp(),
          "lastLogin": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return user;
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      return null;
    }
  }

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": "Guest User",
          "totalGamesPlayed": 0,
          "totalGamesWon": 0,
          "createdAt": FieldValue.serverTimestamp(),
          "lastLogin": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return user;
    } catch (e) {
      debugPrint("Anonymous sign-in failed: $e");
      return null;
    }
  }

  // Sign out method for all authentication types
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint("Sign-out error: $e");
    }
  }
}
