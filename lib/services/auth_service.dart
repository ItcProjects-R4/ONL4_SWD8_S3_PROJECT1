import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmail(String email, String pass) async {
    try {
      final res = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: pass.trim(),
      );

      print("REGISTER SUCCESS: ${res.user?.email}");
      return res.user;
    } on FirebaseAuthException catch (e) {
      print("REGISTER ERROR CODE: ${e.code}");
      print("REGISTER ERROR MESSAGE: ${e.message}");
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

      print("LOGIN SUCCESS: ${res.user?.email}");
      return res.user;
    } on FirebaseAuthException catch (e) {
      print("LOGIN ERROR CODE: ${e.code}");
      print("LOGIN ERROR MESSAGE: ${e.message}");
      return null;
    } catch (e) {
      print("UNKNOWN ERROR: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}