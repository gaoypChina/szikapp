import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'io.dart';
import 'user.dart' as szikapp_user;

class Auth {
  final _auth = FirebaseAuth.instance;
  szikapp_user.User? _user;

  szikapp_user.User? get user => _user;

  Stream<User?> get stateChanges => _auth.authStateChanges();

  User? get firebaseUser => _auth.currentUser;

  Future<UserCredential> _signInWithGoogle() async {
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

  Future<bool> signIn() async {
    await _signInWithGoogle();
    var io = IO();

    var userData = await io.getUser(null);
    var profilePicture = userData.name == 'Guest'
        ? _auth.currentUser!.photoURL
        : '../assets/default.png';
    _user = szikapp_user.User(
        Uri.parse(profilePicture ?? '../assets/default.png'), userData);
    return true;
  }

  Future<bool> signOut() async {
    await _auth.signOut();
    _user = null;
    return true;
  }

  Future<String> getAuthToken() async {
    return _auth.currentUser!.getIdToken();
  }
}
