import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String USER_EMAIL_KEY = 'user_email';

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_EMAIL_KEY);
  }

  static Future<void> clearUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_EMAIL_KEY);
  }
}
