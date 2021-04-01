import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  //Kell még:
  // Lekérni a tokent
  // Ellenőrizni, hogy a User benne van-e az API-ban.
  // Visszatérni User-, vagy User.guest-tel.

  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithUserCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  Future<void> logout() => _auth.signOut();

  Stream<User> get currentUser => _auth.authStateChanges();
}

class AuthBloc {
  final auth = Auth();
  final googleSignin = GoogleSignIn(scopes: ['email']);

  Stream<User> get currentUser => auth.currentUser;

  loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Firebase Sign in
      final result = await auth.signInWithUserCredential(credential);
      print('${result.user.displayName}')
    } catch (error) {
      print(error);
    }
  }
}
