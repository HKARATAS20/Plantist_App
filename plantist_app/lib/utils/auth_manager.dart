import 'package:firebase_auth/firebase_auth.dart';

class AuthManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (error) {
      print("Error: ${error.toString()}");
      throw error;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return signIn(email, password);
      } else {
        return null;
      }
    } catch (error) {
      print("Error: ${error.toString()}");
      throw error;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
