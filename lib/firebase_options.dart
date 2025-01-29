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
    appId: '1:414767726831:android:978f6d9e95ec3dfd211b1a',
    apiKey: 'AIzaSyCFJgW7bDpvt1CV137ggXN8A7Rcr5MP678',
    projectId: 'salesbuddy-d03a4',
    messagingSenderId: '414767726831',
    measurementId: '414767726831',
    storageBucket: 'salesbuddy-d03a4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZpme7DxLmRE9zTycj1durKwq2tDbSVsk',
    appId: '1:675544774928:ios:d64ccdab1ace49a17bcd95',
    messagingSenderId: '675544774928',
    projectId: 'greeme-84d35',
    storageBucket: 'auth-4c590.appspot.com',
    iosClientId:
        '675544774928-3ej0hhnb02h2or4o1d11fa9q94b1rjle.apps.googleusercontent.com',
    iosBundleId: 'com.match.amor',
  );
}
