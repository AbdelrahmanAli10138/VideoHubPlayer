import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String firstTimeKey = "FirstTime";
  static const String profileImageKey = "ProfileImage";
  static const String userNameKey = "username";

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool(firstTimeKey) ?? true;
    if (firstTime) await prefs.setBool(firstTimeKey, false);
    return firstTime;
  }

  static Future<void> saveProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(profileImageKey, path);
  }

  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(profileImageKey);
  }

  static Future<void> deleteProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(profileImageKey);
  }

  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }
}
