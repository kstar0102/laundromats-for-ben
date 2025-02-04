import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/app.dart';
import 'package:laundromats/src/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:  DefaultFirebaseOptions.currentPlatform
  );
  // Manually initialize Firebase
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: "AIzaSyBzR_UuSLe66_dp-Qd-GeugBtK5--2a6Rc", // From api_key
  //       appId:
  //           "1:472459525234:android:91977abcd29cfa8ba816eb", // From mobilesdk_app_id
  //       messagingSenderId: "472459525234", // From project_number
  //       projectId: "laundromats-1c731", // From project_id
  //       storageBucket:
  //           "laundromats-1c731.firebasestorage.app", // From storage_bucket
  //     ),
  //   );
  // }

  runApp(const ProviderScope(child: Laundromats()));
}
