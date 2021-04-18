import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'io.dart';
import 'user.dart' as szikapp_user;

/// Az [Auth] osztály felelős a Firebase és a saját API autentikáció
/// összekapcsolásáért. Menedzseli a bejelentkeztetett felhasználót és adatait.
class Auth {
  final _auth = FirebaseAuth.instance;
  szikapp_user.User? _user;

  /// Singleton osztálypéldány
  static final Auth _instance = Auth._privateConstructor();

  /// Publikus konstruktor, ami visszaadja az egyetlen [Auth] példányt
  factory Auth() => _instance;
  // Privát konstruktor
  Auth._privateConstructor();

  /// Az aktuálisan bejelentkezett felhasználó saját adatstruktúrája
  szikapp_user.User? get user => _user;

  /// Bejelentkezési állapot változásokat reprezentáló [Stream]
  Stream<User?> get stateChanges => _auth.authStateChanges();

  /// Az aktuálisan bejelentkezett Firebase (Google) fiók
  User? get firebaseUser => _auth.currentUser;

  bool get isSignedIn => user != null && _auth.currentUser != null;

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

  /// Bejelentkezés. A függvény a Google autentikáció segítségével
  /// hitelesíti a felhasználót, majd az API által közölt adatok alapján
  /// létrehoz egy vendég vagy egy normál app [szikapp_user.User]-t.
  Future<bool> signIn() async {
    await _signInWithGoogle();
    var io = IO();

    var userData = await io.getUser();
    var profilePicture = userData.name != 'Guest'
        ? _auth.currentUser!.photoURL
        : '../assets/default.png';
    _user = szikapp_user.User(
        Uri.parse(profilePicture ?? '../assets/default.png'), userData);
    return true;
  }

  /// Kijelentkezés. A függvény kijelentkezteti az aktuális Firebase fiókot
  /// használó felhasználót, majd megsemmisíti a belső [szikapp_user.User]
  /// adatstruktúrát.
  Future<bool> signOut() async {
    await _auth.signOut();
    _user = null;
    return true;
  }

  /// Autentikációs token lekérése. A függvény egy JWT-t (JSON Web Token) kér
  /// a Firebase autentikációtól, amivel lehetséges hitelesíteni a felhasználót
  /// a szerveroldali szolgáltatásoknál.
  /// Ha a [forceRefresh] paraméter értéke true, a lejárati idejétől függetlenül
  /// újragenerálja a tokent.
  Future<String> getAuthToken({bool forceRefresh = false}) async {
    return _auth.currentUser!.getIdToken(forceRefresh);
  }
}
