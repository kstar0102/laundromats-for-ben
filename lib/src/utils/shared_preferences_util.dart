import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  // Save user details to SharedPreferences
  static Future<void> saveUserDetails({
    required String userId,
    required String userName,
    required String userEmail,
    required String userExpertIn,
    required String userBusinessTime,
    required String userLaundromatsCount,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('userId', userId);
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', userEmail);
    await prefs.setString('userExpertIn', userExpertIn);
    await prefs.setString('userBusinessTime', userBusinessTime);
    await prefs.setString('userLaundromatsCount', userLaundromatsCount);
  }

  // Retrieve user details (optional for future use)
  static Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'userId': prefs.getString('userId'),
      'userName': prefs.getString('userName'),
      'userEmail': prefs.getString('userEmail'),
      'userExpertIn': prefs.getString('userExpertIn'),
      'userBusinessTime': prefs.getString('userBusinessTime'),
      'userLaundromatsCount': prefs.getString('userLaundromatsCount'),
    };
  }
}
