import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  //Kell még:
  // Lekérni a tokent
  // Ellenőrizni, hogy a User benne van-e az API-ban.
  // Visszatérni User-, vagy User.guest-tel.

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Auth();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

//Az alábbiak helyett: https://firebase.flutter.dev/docs/auth/social#google

  Future<String> singIn({String email, String password}) {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> singUp({String email, String password}) {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'Signed up';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print(e);
    }
  }
}
