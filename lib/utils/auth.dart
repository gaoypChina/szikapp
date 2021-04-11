import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'io.dart';
import 'user.dart' as user;

class Auth {
  //Kell még:
  // Lekérni a tokent
  // Ellenőrizni, hogy a User benne van-e az API-ban.
  // Visszatérni User-, vagy User.guest-tel.

  final _auth = FirebaseAuth.instance;
  user.User? _user;

  user.User? get ownUser => _user;

  Future<void> logout() => _auth.signOut();

  Stream<User?> get stateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
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

      var profilePicture = _auth.currentUser!.photoURL;
      var userData = await io.getUser(null);
      _user = user.User(Uri.parse(profilePicture ?? ''), userData);
    } on Exception catch (e) {
      var userEmail = _auth.currentUser!.email;
      _user = user.User.guest(email: userEmail ?? '');
      return true;
    }
  }

  Future<bool?> signOut() async {
    await logout();
    _user = null;
  }

  Future<String> getAuthToken() {
    return _auth.currentUser!.getIdToken();
  }
}
