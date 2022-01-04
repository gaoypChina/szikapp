import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_data.dart';
import 'exceptions.dart';

import 'io.dart';
import 'user.dart' as szikapp_user;

/// Az [AuthManager] osztály felelős a Firebase és a saját API autentikáció
/// összekapcsolásáért. Menedzseli a bejelentkeztetett felhasználót és adatait.
class AuthManager extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  szikapp_user.User? _user;
  bool _signedIn = false;

  /// Singleton osztálypéldány
  static final AuthManager _instance = AuthManager._privateConstructor();

  /// Publikus konstruktor, ami visszaadja az egyetlen [AuthManager] példányt
  factory AuthManager() => _instance;
  // Privát konstruktor
  AuthManager._privateConstructor();

  /// Az aktuálisan bejelentkezett felhasználó saját adatstruktúrája
  szikapp_user.User? get user => _user;

  /// Bejelentkezési állapot változásokat reprezentáló [Stream]
  Stream<User?> get stateChanges => _auth.authStateChanges();

  /// Az aktuálisan bejelentkezett Firebase (Google) fiók
  User? get firebaseUser => _auth.currentUser;

  bool get isSignedIn => _signedIn;

  /// Belső autentikáció segédfüggvény, ami a Google saját metódusával
  /// autentikálja a felhasználót
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

  /// Csendes bejelentkezés. A függvény autentikál a saját APInk felé,
  /// amennyiben a felhasználó már be van jelentkezve a Google fiókjával.
  /// Létrehoz egy vendég vagy egy normál app [szikapp_user.User]-t.
  Future<void> signInSilently() async {
    if (isSignedIn) {
      return;
    } else if (_auth.currentUser == null) {
      _signedIn = false;
      notifyListeners();
      return;
    }
    try {
      var io = IO(manager: _instance);

      var userData = await io.getUser();
      var profilePicture = userData.name != 'Guest'
          ? _auth.currentUser!.photoURL
          : '../assets/default.png';
      _user = szikapp_user.User(
          Uri.parse(profilePicture ?? '../assets/default.png'), userData);
      _signedIn = true;
      notifyListeners();
    } on Exception catch (e) {
      _signedIn = false;
      throw AuthException(e.toString());
    }
  }

  /// Bejelentkezés. A függvény a Google autentikáció segítségével
  /// hitelesíti a felhasználót, majd az API által közölt adatok alapján
  /// létrehoz egy vendég vagy egy normál app [szikapp_user.User]-t.
  Future<void> signIn() async {
    if (isSignedIn) {
      return;
    }
    try {
      await _signInWithGoogle();
      var io = IO(manager: _instance);

      var userData = await io.getUser();
      var profilePicture = userData.name != 'Guest'
          ? _auth.currentUser!.photoURL
          : '../assets/default.png';
      _user = szikapp_user.User(
          Uri.parse(profilePicture ?? '../assets/default.png'), userData);
      _signedIn = true;
      notifyListeners();
    } on Exception catch (e) {
      _signedIn = false;
      throw AuthException(e.toString());
    }
  }

  /// Kijelentkezés. A függvény kijelentkezteti az aktuális Firebase fiókot
  /// használó felhasználót, majd megsemmisíti a belső [szikapp_user.User]
  /// adatstruktúrát.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      _signedIn = false;
      notifyListeners();
    } on Exception catch (e) {
      throw AuthException(e.toString());
    }
  }

  /// Autentikációs token lekérése. A függvény egy JWT-t (JSON Web Token) kér
  /// a Firebase autentikációtól, amivel lehetséges hitelesíteni a felhasználót
  /// a szerveroldali szolgáltatásoknál.
  /// Ha a [forceRefresh] paraméter értéke true, a lejárati idejétől függetlenül
  /// újragenerálja a tokent.
  Future<String> getAuthToken({bool forceRefresh = false}) async {
    return _auth.currentUser!.getIdToken(forceRefresh);
  }

  Future<bool> pushUserUpdate() async {
    if (isSignedIn) {
      var io = IO();
      var data = UserData.fromUser(user!);
      await io.putUser(data);
      return true;
    }
    return false;
  }

  Future<bool> pullUserUpdate() async {
    if (isSignedIn) {
      var io = IO();

      var userData = await io.getUser();
      var profilePicture = userData.name != 'Guest'
          ? _auth.currentUser!.photoURL
          : '../assets/default.png';
      _user = szikapp_user.User(
          Uri.parse(profilePicture ?? '../assets/default.png'), userData);
      return true;
    }
    return false;
  }
}
