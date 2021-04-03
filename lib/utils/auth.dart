import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:szikapp/utils/user.dart' as user;

import 'io.dart';

class Auth {
  //Kell még:
  // Lekérni a tokent
  // Ellenőrizni, hogy a User benne van-e az API-ban.
  // Visszatérni User-, vagy User.guest-tel.

  final _auth = FirebaseAuth.instance;
  user.User? _user;

  Future<void> logout() => _auth.signOut();

  Stream<User?> get stateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ) as GoogleAuthCredential;

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<bool?> signIn() async {
    await signInWithGoogle();
    try {
      var io = IO();
      await io.getUser(null);
    } on Exception catch (e) {
      _user =
          user.User.guest(email: email); // emailt kiszedni a currentUser-ből
      return true;
    }
  }

  Future<String> getAuthToken([bool forceRefresh = false]) {
    return _delegate.getIdToken(forceRefresh);
  }
}
