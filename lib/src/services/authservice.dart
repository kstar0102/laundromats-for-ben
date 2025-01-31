import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final logger = Logger();

  final String baseUrl = 'http://192.168.141.105:5000/api/auth';
  static const String uploadUrl = 'http://146.190.117.4:5000/image/upload';

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

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    required String roleExpertIn,
    required String roleBusinessTime,
    required String roleLaundromatsCount,
  }) async {
    final Uri url = Uri.parse('$baseUrl/signup');

    Map<String, String> requestData = {
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "role_expertIn": roleExpertIn,
      "role_businessTime": roleBusinessTime,
      "role_laundromatsCount": roleLaundromatsCount,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> uploadFile(File file, String fileName) async {
    try {
      // Read the file as bytes and encode it to base64
      final bytes = await file.readAsBytes();
      final base64Content = base64Encode(bytes);

      // Prepare the JSON payload
      final payload = {
        "file": {
          "type": "image", // Adjust if there are other types
          "name": fileName,
          "content": base64Content,
        },
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(uploadUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      // Check response and return result
      if (response.statusCode == 200) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
