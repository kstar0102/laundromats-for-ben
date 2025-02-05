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

  final String baseUrl = 'http://192.168.141.105:5000/api';
  // final String baseUrl = 'http://146.190.117.4:5000/api';
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

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    final Uri url = Uri.parse('$baseUrl/auth/signin');

    Map<String, String> requestData = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          "success": true,
          "data": responseData,
          "token": responseData["token"]
        };
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

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    required String roleExpertIn,
    required String roleBusinessTime,
    required String roleLaundromatsCount,
  }) async {
    final Uri url = Uri.parse('$baseUrl/auth/signup');

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
        final responseData = jsonDecode(response.body);
        return {
          "success": true,
          "data": jsonDecode(response.body),
          "userId": responseData["userId"]
        };
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

  Future<Map<String, dynamic>> uploadFile(
      File file, String fileName, String type) async {
    try {
      // Read the file as bytes and encode it to base64
      final bytes = await file.readAsBytes();
      final base64Content = base64Encode(bytes);

      // Prepare the JSON payload
      final payload = {
        "file": {
          "type": type, // Adjust if there are other types
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

  Future<Map<String, dynamic>> createQuestion({
    required String userId,
    required String question,
    required String brand,
    required String serialNumber,
    required String pounds,
    required String year,
    required String category,
    required String tags,
    String? uploadedImageUrl, // Nullable
    String? uploadedFileUrl, // Nullable
  }) async {
    String apiUrl = '$baseUrl/question/createquestion';

    // Prepare request body
    final Map<String, dynamic> requestBody = {
      "userID": userId,
      "question": question,
      "brand": brand,
      "serial_number": serialNumber,
      "pounds": pounds,
      "year": year,
      "category": category,
      "tags": tags,
      "image": "",
      "file": ""
    };

    // Only include file/image if they are not null
    if (uploadedImageUrl != null) requestBody["image"] = uploadedImageUrl;
    if (uploadedFileUrl != null) requestBody["file"] = uploadedFileUrl;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {"success": true, "message": "Question created successfully"};
      } else if (response.statusCode == 400 &&
          jsonResponse.containsKey("missingFields")) {
        return {
          "success": false,
          "message": "Validation error",
          "missingFields": List<String>.from(jsonResponse["missingFields"])
        };
      } else {
        return {
          "success": false,
          "message": jsonResponse['message'] ?? "Unknown error occurred"
        };
      }
    } catch (error) {
      return {"success": false, "message": "Failed to create question: $error"};
    }
  }

  Future<List<dynamic>> fetchQuestionsWithAnswers() async {
    final url = Uri.parse('$baseUrl/question/allquestionwithanswer');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['questions'];
      } else {
        throw Exception('Failed to fetch questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  Future<Map<String, dynamic>> createOrUpdateLikeDislike({
    required int userId,
    required int questionId,
    required int type,
  }) async {
    final url = Uri.parse('$baseUrl/likes/likeordislike');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': userId,
          'question_id': questionId,
          'type': type, // 1 for like, 0 for dislike
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Return the parsed JSON response
      } else {
        throw Exception(
            'Failed to update like/dislike: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating like/dislike: $e');
    }
  }

  Future<List<dynamic>> fetchUserQuestionsWithAnswers(int userId) async {
    final url =
        Uri.parse('$baseUrl/question/allquestionwithanswerbyid/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['questions'];
      } else {
        throw Exception(
            'Failed to fetch user questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user questions: $e');
    }
  }

  Future<Map<String, dynamic>> submitAnswer({
    required int questionId,
    required int userId,
    required String answer,
  }) async {
    final url = Uri.parse('$baseUrl/question/createanswer');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'question_id': questionId,
          'user_id': userId,
          'answer': answer,
          'isWho': 'user', // Define the answer type
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to submit answer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting answer: $e');
    }
  }

  Future<List<dynamic>> searchQuestions(
      int userId, String search, List<String> categories) async {
    final url = Uri.parse('$baseUrl/question/searchmyquestion');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user_id": userId,
          "search": search,
          "categories": categories,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['questions'];
      } else {
        throw Exception('Failed to search questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching questions: $e');
    }
  }

  Future<List<dynamic>> searchQuestionsAll(
      String search, List<String> categories) async {
    final url = Uri.parse('$baseUrl/question/searchquestion');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "search": search,
          "categories": categories,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['questions'];
      } else {
        throw Exception('Failed to search questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching questions: $e');
    }
  }
}
