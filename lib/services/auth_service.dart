import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// SIGN UP
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _db.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Welcome notification
    await _db
        .collection('users')
        .doc(cred.user!.uid)
        .collection('notifications')
        .add({
      'title': 'Welcome to Tracely',
      'body': 'You’re officially in. Time to learn smarter.',
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  /// LOGIN
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}
