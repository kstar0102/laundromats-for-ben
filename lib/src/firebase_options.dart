import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    appId: '1:472459525234:android:91977abcd29cfa8ba816eb',
    apiKey: 'AIzaSyBzR_UuSLe66_dp-Qd-GeugBtK5--2a6Rc',
    projectId: 'laundromats-1c731',
    messagingSenderId: '472459525234',
    measurementId: '472459525234',
    storageBucket: 'laundromats-1c731.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWHRV3RgNXFTdauZBZmdzjb0N77slJY98',
    appId: '1:472459525234:ios:e0745400d16e52fca816eb',
    messagingSenderId: '472459525234',
    projectId: 'laundromats-1c731',
    storageBucket: 'laundromats-1c731.firebasestorage.app',
    iosClientId:
        '472459525234-mvq5km2hdkfddkhaqc86ik7aem3j84vh.apps.googleusercontent.com',
    iosBundleId: 'com.app.laundromats',
  );
}
