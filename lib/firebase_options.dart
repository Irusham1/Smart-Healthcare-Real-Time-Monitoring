// TODO Implement this library.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBGIDsURC_bD9LVz6o3E6ldAt9e8ZgGe_A',
    authDomain: 'iot-health-monitoring-sy-b19b8.firebaseapp.com',
    databaseURL:
        'https://iot-health-monitoring-sy-b19b8-default-rtdb.firebaseio.com/',
    projectId: 'iot-health-monitoring-sy-b19b8',
    storageBucket: 'iot-health-monitoring-sy-b19b8.appspot.com',
    messagingSenderId: '790006353463',
    appId: '1:790006353463:web:18e0c68764041a75b979b2',
    measurementId: 'G-BGEX7W9H8J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGIDsURC_bD9LVz6o3E6ldAt9e8ZgGe_A',
    appId: '1:790006353463:web:18e0c68764041a75b979b2',
    messagingSenderId: '790006353463',
    projectId: 'iot-health-monitoring-sy-b19b8',
    databaseURL:
        'https://iot-health-monitoring-sy-b19b8-default-rtdb.firebaseio.com/',
    storageBucket: 'iot-health-monitoring-sy-b19b8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: 'your-ios-app-id',
    messagingSenderId: 'your-ios-msg-id',
    projectId: 'iot-health-monitoring-sy-b19b8',
    databaseURL:
        'https://iot-health-monitoring-sy-b19b8-default-rtdb.firebaseio.com/',
    storageBucket: 'iot-health-monitoring-sy-b19b8.appspot.com',
    iosClientId: 'your-ios-client-id',
    iosBundleId: 'your-ios-bundle-id',
  );

  static const FirebaseOptions macos = ios;
}
