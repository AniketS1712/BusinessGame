// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBbxd8h6qf7zru1CsXZHx4REo7qpoB2W_8',
    appId: '1:631482665751:web:61748f6ebec6f7907cc552',
    messagingSenderId: '631482665751',
    projectId: 'business-game-efb38',
    authDomain: 'business-game-efb38.firebaseapp.com',
    storageBucket: 'business-game-efb38.firebasestorage.app',
    measurementId: 'G-657YQKDTDP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_02EPaTPS78jz4w-6oUuCAhrXhYQiwEY',
    appId: '1:631482665751:android:44775c68b8a7ecf17cc552',
    messagingSenderId: '631482665751',
    projectId: 'business-game-efb38',
    storageBucket: 'business-game-efb38.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCamDA3xATp1Qf-XczAgK2TIUOhOdybTuE',
    appId: '1:631482665751:ios:18ee81877383e82f7cc552',
    messagingSenderId: '631482665751',
    projectId: 'business-game-efb38',
    storageBucket: 'business-game-efb38.firebasestorage.app',
    iosClientId:
        '631482665751-stdbjj3ej7u4agk6lmt17r154sq4vmdc.apps.googleusercontent.com',
    iosBundleId: 'com.example.businessGame',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCamDA3xATp1Qf-XczAgK2TIUOhOdybTuE',
    appId: '1:631482665751:ios:18ee81877383e82f7cc552',
    messagingSenderId: '631482665751',
    projectId: 'business-game-efb38',
    storageBucket: 'business-game-efb38.firebasestorage.app',
    iosClientId:
        '631482665751-stdbjj3ej7u4agk6lmt17r154sq4vmdc.apps.googleusercontent.com',
    iosBundleId: 'com.example.businessGame',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBbxd8h6qf7zru1CsXZHx4REo7qpoB2W_8',
    appId: '1:631482665751:web:2cb7a3f693092bb97cc552',
    messagingSenderId: '631482665751',
    projectId: 'business-game-efb38',
    authDomain: 'business-game-efb38.firebaseapp.com',
    storageBucket: 'business-game-efb38.firebasestorage.app',
    measurementId: 'G-KCJFP221D0',
  );
}
