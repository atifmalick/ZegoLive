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

  // static const FirebaseOptions android = FirebaseOptions(
  //   apiKey: 'AIzaSyD9Bl2LzeMmOLjexmvb6Fe3qE05c80V06E',
  //   appId: '"1:266472249089:android:37ef43512d5c477350ad00',
  //   messagingSenderId: '266472249089',
  //   projectId: 'tapd-d',
  //   databaseURL: 'https://tapd-d.firebaseio.com',
  //   storageBucket: 'tapd-d.appspot.com',
  // );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:
        'AIzaSyCMcVlZIvH4x5cfeq1zkO_8azop-UXQSPg', //'AIzaSyAJ_CppqQHifNDkkjkt7LncjtXc2jjBcqI',
    appId: '1:841995465624:android:5eaec23f138c11481df1ed',
    messagingSenderId: '841995465624',
    projectId: 'sstandardtapp',
    databaseURL: 'https://sstandardtapp.firebaseio.com',
    storageBucket: 'sstandardtapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7lSD4MJI9gosFZZ9tl5s_FnJwbbJ8ZW4',
    appId: '1:841995465624:ios:bccf2abab8b3d81c1df1ed',
    messagingSenderId: '841995465624',
    projectId: 'sstandardtapp',
    databaseURL: 'https://sstandardtapp.firebaseio.com',
    storageBucket: 'sstandardtapp.appspot.com',
    androidClientId:
        '841995465624-6q1aapgh1bff2mqq8dpp3vgqe34q9n51.apps.googleusercontent.com',
    iosClientId:
        '841995465624-sdgq0uj449b2dmop197gel027070185r.apps.googleusercontent.com',
    iosBundleId: 'com.ss.tapp',
  );
}
