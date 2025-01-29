import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final logger = Logger();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      logger.i("Error during Google sign-in: $e");
      return null;
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Correct way to get the token
        final String? token = result.accessToken?.tokenString;

        if (token != null) {
          logger.i("Facebook Token: $token");

          final OAuthCredential credential =
              FacebookAuthProvider.credential(token);
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          return userCredential.user;
        } else {
          logger.i("Facebook login failed: Token is null");
          return null;
        }
      } else {
        logger.i("Facebook login failed: ${result.message}");
        return null;
      }
    } catch (e) {
      logger.i("Error during Facebook sign-in: $e");
      return null;
    }
  }
}
