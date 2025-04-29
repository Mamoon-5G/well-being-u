import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellbeingu/models/user_model.dart';
import 'package:wellbeingu/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        _setLoading(true);
        _user = await _authService.getUserData();
        _setLoading(false);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = user;
      _setLoading(false);
      return user != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = user;
      _setLoading(false);
      return user != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> refreshUserData() async {
    try {
      _setLoading(true);
      _user = await _authService.getUserData();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile(String name, String? photoUrl) async {
    try {
      if (_user == null) return;

      _setLoading(true);
      final updatedUser = _user!.copyWith(
        name: name,
        photoUrl: photoUrl,
      );

      await _authService.updateUserData(updatedUser);
      _user = updatedUser;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
}

// class AuthService {
//   ///get firestore instance
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   get currentUserEmail {
//     return _firebaseAuth.currentUser!.email!;
//   }

//   ///login user with email and password
//   Future<UserCredential> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final UserCredential userCredential = await _firebaseAuth
//           .signInWithEmailAndPassword(email: email, password: password);

//       ///return user data after login
//       return userCredential;
//     }
//     ///catch error from firebase
//     on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     }
//   }

//   ///logout
//   Future<void> logout() async {
//     ///logout current user
//     await _firebaseAuth.signOut();
//   }

//   ///register
//   Future<UserCredential> register({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final UserCredential userCredential = await _firebaseAuth
//           .createUserWithEmailAndPassword(email: email, password: password);

//       ///store data in firestore if they register
//       final uid = userCredential.user!.uid;
//       final CollectionReference reference = _firebaseFirestore.collection(
//         'Users',
//       );
//       await reference.doc(email.toLowerCase()).set({
//         'email': email.toLowerCase(),
//         'uid': uid,
//       });

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     }
//   }
// }
