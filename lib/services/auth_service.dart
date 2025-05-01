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

      if (userCredential.user != null) {
        // Create a user document in Firestore
        final userModel = UserModel(
          id: userCredential.user!.uid,
          name: name ?? "User", // Default name if not provided
          email: email,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      log('General Error registering user: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          // Explicit type casting to avoid List<Object?> error
          final userData = userDoc.data() as Map<String, dynamic>;
          return UserModel.fromMap({
            'id': userCredential.user!.uid,
            ...userData,
          });
        }
        
        // If user document doesn't exist, create one
        final newUser = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: "User",
          createdAt: DateTime.now(),
        );
        
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toMap());
            
        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      log('General Error signing in: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Error signing out: $e');
      rethrow;
    }
  }

  // Get current user data
  Future<UserModel?> getUserData() async {
    try {
      if (currentUser == null) return null;

      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return UserModel.fromMap({
          'id': currentUser!.uid,
          ...userData,
        });
      }
      return null;
    } catch (e) {
      log('Error getting user data: $e');
      rethrow;
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

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      if (currentUser != null) {
        // Delete from Firestore first
        await _firestore.collection('users').doc(currentUser!.uid).delete();
        // Then delete auth account
        await currentUser!.delete();
      }
    } catch (e) {
      log('Error deleting account: $e');
      rethrow;
    }
  }
}
// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:wellbeingu/models/user_model.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Get current user
//   User? get currentUser => _auth.currentUser;

//   // Stream of auth changes
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // Register user
//   Future<UserModel?> createUserWithEmailAndPassword({
//     required String email,
//     required String password,
//     String? name,
//   }) async {
//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (userCredential.user != null) {
//         final userModel = UserModel(
//           id: userCredential.user!.uid,
//           name: name ?? "test",
//           email: email,
//         );

//         await _firestore
//             .collection('users')
//             .doc(userCredential.user!.uid)
//             .set(userModel.toMap());

//         return userModel;
//       }
//       return null;
//     } catch (e) {
//       log('Error registering user: $e');
//       rethrow;
//     }
//   }

//   // Login user
//   Future<UserModel?> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (userCredential.user != null) {
//         final uid = userCredential.user!.uid;
//         final userDoc = await _firestore.collection('users').doc(uid).get();

//         if (userDoc.exists) {
//           return UserModel.fromMap({
//             'id': uid,
//             ...userDoc.data()!,
//           });
//         }
//       }

//       return null;
//     } catch (e) {
//       log('Error signing in: $e');
//       rethrow;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // Get current user data from Firestore
//   Future<UserModel?> getUserData() async {
//     try {
//       if (currentUser == null) return null;

//       final userDoc =
//           await _firestore.collection('users').doc(currentUser!.uid).get();

//       if (userDoc.exists) {
//         return UserModel.fromMap({'id': currentUser!.uid, ...userDoc.data()!});
//       }

//       return null;
//     } catch (e) {
//       log('Error getting user data: $e');
//       return null;
//     }
//   }

//   // Update user data
//   Future<void> updateUserData(UserModel userModel) async {
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userModel.id)
//           .update(userModel.toMap());
//     } catch (e) {
//       log('Error updating user data: $e');
//       rethrow;
//     }
//   }
// }