import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/models.dart' as szikapp_user;
import '../utils/utils.dart';
import 'business.dart';

enum SignInMethod {
  google,
  apple,
}

/// Az [AuthManager] osztály felelős a Firebase és a saját API autentikáció
/// összekapcsolásáért. Menedzseli a bejelentkeztetett felhasználót és adatait.
class AuthManager extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  szikapp_user.User? _user;
  bool _signedIn = false;
  bool _isGuest = true;
  SignInMethod? _method;

  /// Singleton osztálypéldány
  static final AuthManager _instance = AuthManager._privateConstructor();

  /// Publikus konstruktor, ami visszaadja az egyetlen [AuthManager] példányt
  factory AuthManager() => _instance;
  // Privát konstruktor
  AuthManager._privateConstructor();

  /// Az aktuálisan bejelentkezett felhasználó saját adatstruktúrája
  szikapp_user.User? get user => _user;

  bool get isUserGuest => _isGuest;
  SignInMethod? get signInMethod => _method;

  /// Bejelentkezési állapot változásokat reprezentáló [Stream]
  Stream<User?> get stateChanges => _auth.authStateChanges();

  /// Az aktuálisan bejelentkezett Firebase (Google) fiók
  User? get firebaseUser => _auth.currentUser;

  ///Indicates whether there is an authenticated user.
  bool get isSignedIn => _signedIn;

  /// Belső autentikáció segédfüggvény, ami a Google saját metódusával
  /// autentikálja a felhasználót
  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn(scopes: [
      'openid',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.messaging',
    ]).signIn();

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

  Future<UserCredential> _signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(input: rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.szik.szikappsigninservice',
        redirectUri: Uri.parse(
          'https://szikapp-18.firebaseapp.com/__/auth/handler',
        ),
      ),
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  /// Csendes bejelentkezés. A függvény autentikál a saját APInk felé,
  /// amennyiben a felhasználó már be van jelentkezve a Google fiókjával.
  /// Létrehoz egy vendég vagy egy normál app [szikapp_user.User]-t.
  Future<void> signInSilently() async {
    if (isSignedIn) {
      return;
    } else if (_auth.currentUser == null) {
      return;
    }
    try {
      var io = IO(manager: _instance);

      _user = await io.getUser();
      _user?.profilePicture = _auth.currentUser!.photoURL;
      _isGuest = false;
      _signedIn = true;
      NotificationManager.instance.saveTokenToDatabase(null);
      notifyListeners();
    } on IOClientException catch (e) {
      if (e.code == 401) {
        _user = szikapp_user.User(
          id: 'u999',
          name: _auth.currentUser!.displayName ?? '',
          email: _auth.currentUser!.email ?? '',
          lastUpdate: DateTime.now(),
          profilePicture: _auth.currentUser!.photoURL,
        );
        _isGuest = true;
        _signedIn = true;
        notifyListeners();
      } else {
        _signedIn = false;
        throw AuthException(e.toString());
      }
    } on Exception catch (e) {
      _signedIn = false;
      throw AuthException(e.toString());
    }
  }

  /// Bejelentkezés. A függvény a Google autentikáció segítségével
  /// hitelesíti a felhasználót, majd az API által közölt adatok alapján
  /// létrehoz egy vendég vagy egy normál app [szikapp_user.User]-t.
  Future<void> signIn({
    required SignInMethod method,
  }) async {
    if (isSignedIn) {
      return;
    }
    try {
      method == SignInMethod.google
          ? await _signInWithGoogle()
          : await _signInWithApple();
      var io = IO(manager: _instance);

      _user = await io.getUser();
      _user?.profilePicture = _auth.currentUser!.photoURL;
      _isGuest = false;
      _signedIn = true;
      _method = method;
      NotificationManager.instance.saveTokenToDatabase(null);
      notifyListeners();
    } on IOClientException catch (e) {
      if (e.code == 401) {
        _user = szikapp_user.User(
          id: 'u999',
          name: _auth.currentUser!.displayName ?? '',
          email: _auth.currentUser!.email ?? '',
          lastUpdate: DateTime.now(),
          profilePicture: _auth.currentUser!.photoURL,
        );
        _isGuest = true;
        _signedIn = true;
        _method = method;
        notifyListeners();
      } else {
        _signedIn = false;
        throw AuthException(e.toString());
      }
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
      if (!_isGuest) {
        Settings.instance.savePreferences();
        await pushUserUpdate();
      }
      await _auth.signOut();
      await GoogleSignIn().signOut();
      _user = null;
      _isGuest = true;
      _signedIn = false;
      notifyListeners();
    } on Exception catch (e) {
      throw AuthException(e.toString());
    }
  }

  ///Fiók törlése. A függvény kijelentkezteti, majd törli a felhasználó fiókját.
  Future<void> deleteAccount() async {
    try {
      if (!_isGuest) {
        Settings.instance.savePreferences();
        await pushUserUpdate();
      }
      await GoogleSignIn().signOut();
      await _auth.currentUser?.delete();
      _user = null;
      _isGuest = true;
      _signedIn = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
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

  ///Synchronizes local updates on the user profile.
  Future<bool> pushUserUpdate() async {
    if (isSignedIn && !isUserGuest) {
      var io = IO();
      await io.putUser(data: _user!);
      return true;
    }
    return false;
  }

  ///Synchronizes remote updates on the user profile.
  Future<bool> pullUserUpdate() async {
    if (isSignedIn && !isUserGuest) {
      var io = IO();

      _user = await io.getUser();
      _user?.profilePicture = _auth.currentUser!.photoURL;
      return true;
    }
    return false;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString({required String input}) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
