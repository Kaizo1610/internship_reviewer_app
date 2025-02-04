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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwcRQDqbmJhiNJXB3-TOXMdqpdiR_DYN8',
    appId: '1:818418295505:android:f7d63a7ac71e459d515bf0',
    messagingSenderId: '818418295505',
    projectId: 'internova-4fdf5',
    databaseURL: 'https://internova-4fdf5-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'internova-4fdf5.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD_Hi6yq5rKOzXc8r-rEhVAUZb25YhkcKE',
    appId: '1:818418295505:web:99ad39cd45990ced515bf0',
    messagingSenderId: '818418295505',
    projectId: 'internova-4fdf5',
    authDomain: 'internova-4fdf5.firebaseapp.com',
    databaseURL: 'https://internova-4fdf5-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'internova-4fdf5.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD_Hi6yq5rKOzXc8r-rEhVAUZb25YhkcKE',
    appId: '1:818418295505:web:1c5c97adc7723144515bf0',
    messagingSenderId: '818418295505',
    projectId: 'internova-4fdf5',
    authDomain: 'internova-4fdf5.firebaseapp.com',
    databaseURL: 'https://internova-4fdf5-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'internova-4fdf5.firebasestorage.app',
  );

}