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
    apiKey: 'AIzaSyB6992TFRebzB9MlgLjPe41RBF0lu18be4',
    appId: '1:1042753723106:web:45bb32f41f1aae80f49cbb',
    messagingSenderId: '1042753723106',
    projectId: 'todo-list-267de',
    authDomain: 'todo-list-267de.firebaseapp.com',
    storageBucket: 'todo-list-267de.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxjbFuDnrIoRDCgY3lwS3evs5H9Oaxwq8',
    appId: '1:1042753723106:android:f774b4400b960a6bf49cbb',
    messagingSenderId: '1042753723106',
    projectId: 'todo-list-267de',
    storageBucket: 'todo-list-267de.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVPAHbC3wwooTG6rN77RDBWw9e_AKMvjA',
    appId: '1:1042753723106:ios:7d09229d79e8b4daf49cbb',
    messagingSenderId: '1042753723106',
    projectId: 'todo-list-267de',
    storageBucket: 'todo-list-267de.firebasestorage.app',
    iosBundleId: 'com.example.todoList',
  );
}
