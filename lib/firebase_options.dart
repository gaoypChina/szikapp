// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1II7445fOB2gg-BaSQ96DSUbYFWZK8gE',
    appId: '1:590618268030:android:da008ba4dae644df50e32f',
    messagingSenderId: '590618268030',
    projectId: 'szikapp-18',
    storageBucket: 'szikapp-18.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAr1y6o6j4MZpfAvJBVjzy7hB59WJ04TOM',
    appId: '1:590618268030:ios:f5ec0a6bbef6f32950e32f',
    messagingSenderId: '590618268030',
    projectId: 'szikapp-18',
    storageBucket: 'szikapp-18.appspot.com',
    androidClientId:
        '590618268030-23fm2bvjtnv4b3esr5c40itk7ac1fg8g.apps.googleusercontent.com',
    iosClientId:
        '590618268030-r22274ert0j8l8f99sctsumr7t26lova.apps.googleusercontent.com',
    iosBundleId: 'com.szik.szikapp',
  );
}
