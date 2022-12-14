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
    apiKey: 'AIzaSyBFk4fn0HHdLL_ZW8RxFSvyqR0gecCJY08',
    appId: '1:728766484396:web:211ef1557a03b0f0983409',
    messagingSenderId: '728766484396',
    projectId: 'kiwihabitapp-5f514',
    authDomain: 'kiwihabitapp-5f514.firebaseapp.com',
    storageBucket: 'kiwihabitapp-5f514.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvp4VmVEYrB0x3KhFP-q7uMsRm7G50TYU',
    appId: '1:728766484396:android:13081d73af914b27983409',
    messagingSenderId: '728766484396',
    projectId: 'kiwihabitapp-5f514',
    storageBucket: 'kiwihabitapp-5f514.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3MG2TxhZioc1qtIqeiYBKTWNgiNYW1jc',
    appId: '1:728766484396:ios:2d84d1df978e8e91983409',
    messagingSenderId: '728766484396',
    projectId: 'kiwihabitapp-5f514',
    storageBucket: 'kiwihabitapp-5f514.appspot.com',
    iosClientId:
        '728766484396-f6h02lkm7rdc180v05n5dh7os2j274lo.apps.googleusercontent.com',
    iosBundleId: 'com.example.kiwihabitapp',
  );
}
