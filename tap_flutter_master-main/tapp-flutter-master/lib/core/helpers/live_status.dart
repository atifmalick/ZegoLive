import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  // Method to store the liveStreamOn boolean value and postId
  static Future<void> setLiveStreamData(
      bool liveStreamOn, String postId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('liveStreamOn', liveStreamOn);
    await prefs.setString('postId', postId);
  }

  // Method to retrieve the liveStreamOn boolean value
  static Future<bool> getLiveStreamOn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('liveStreamOn') ??
        false; // Default value is false if not set
  }

  // Method to retrieve the postId
  static Future<String?> getPostId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('postId'); // Returns null if not set
  }
}
