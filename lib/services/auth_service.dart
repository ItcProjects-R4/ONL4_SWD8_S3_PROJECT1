import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<User?> registerWithEmail(String email, String pass) async {
    try {
      final res = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: pass.trim(),
      );
      return res.user;
    } on FirebaseAuthException catch (e) {
      print("REGISTER ERROR: ${e.code}");
      return null;
    } catch (e) {
      print("UNKNOWN ERROR: $e");
      return null;
    }
  }

  Future<User?> loginWithEmail(String email, String pass) async {
    try {
      final res = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: pass.trim(),
      );
      return res.user;
    } on FirebaseAuthException catch (e) {
      print("LOGIN ERROR: ${e.code}");
      return null;
    } catch (e) {
      print("UNKNOWN ERROR: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  User? get currentUser => _auth.currentUser;
}