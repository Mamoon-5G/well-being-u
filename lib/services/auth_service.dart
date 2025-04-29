import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellbeingu/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<UserModel?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("USER" + userCredential.toString());
      if (userCredential.user != null) {
        // Create a user document in Firestore
        final userModel = UserModel(
          id: userCredential.user!.uid,
          name: name ?? "test",
          email: email,
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());

        return userModel;
      }
      return null;
    } catch (e) {
      log('Error registering user: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // final userDoc =
        //     await _firestore
        //         .collection('users')
        //         .doc(userCredential.user!.uid)
        //         .get();

        // if (userDoc.exists) {
        //   return UserModel.fromMap({
        //     'id': userCredential.user!.uid,
        //     ...userDoc.data()!,
        //   });
        // }

        ///store data in firestore if they register
        final uid = userCredential.user!.uid;
        final CollectionReference reference = _firestore.collection('Users');
        await reference.doc(email.toLowerCase()).set({
          'email': email.toLowerCase(),
          'uid': uid,
        });
      }
      return null;
    } catch (e) {
      log('Error signing in: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user data
  Future<UserModel?> getUserData() async {
    try {
      if (currentUser == null) return null;

      final userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (userDoc.exists) {
        return UserModel.fromMap({'id': currentUser!.uid, ...userDoc.data()!});
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user data
  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.id)
          .update(userModel.toMap());
    } catch (e) {
      log('Error updating user data: $e');
      rethrow;
    }
  }
}
