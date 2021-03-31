import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  //Publikus változók - amik a specifikációban vannak

  //Privát változók - amikre szerinted szükség van

  //Setterek és getterek - amennyiben vannak validálandó publikus váltózóid

  //Publikus függvények aka Interface - amit a specifikáció megkövetel

  //Privát függvények - amikre szerinted szükség van

  //Kell még:
  // Lekérni a tokent
  // Ellenőrizni, hogy a User benne van-e az API-ban.
  // Visszatérni User-, vagy User.guest-tel.
  // Beépíteni a google-signin json fájlt az android/app mappába

  final FirebaseAuth _firebaseAuth;

  Auth(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

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
