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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCPBF4X1zfCtinaR1Hd6zqSZQKWaPDT8G4',
    appId: '1:1016181325971:web:2beeffe9d51cef93c4cd66',
    messagingSenderId: '1016181325971',
    projectId: 'socially-app-5b697',
    authDomain: 'socially-app-5b697.firebaseapp.com',
    storageBucket: 'socially-app-5b697.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDw1x-EbwHA9FiR4rThuTnfN-50rzFOCO4',
    appId: '1:1016181325971:android:d68da3b0826a77fbc4cd66',
    messagingSenderId: '1016181325971',
    projectId: 'socially-app-5b697',
    storageBucket: 'socially-app-5b697.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcffGA2Q_wEvLEKu3ysfVxo57pbsWGicc',
    appId: '1:1016181325971:ios:39e5f0affc09479fc4cd66',
    messagingSenderId: '1016181325971',
    projectId: 'socially-app-5b697',
    storageBucket: 'socially-app-5b697.firebasestorage.app',
    iosBundleId: 'com.example.sociallyApp',
  );
}
