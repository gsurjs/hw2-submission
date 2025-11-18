import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign Up - Creates Auth User AND Firestore Document 
  Future<String?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      // 1. Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // 2. Store specific user details in Cloud Firestore 
      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'email': email,
        'registrationDatetime': DateTime.now().toIso8601String(), // 
      });

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign In 
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}