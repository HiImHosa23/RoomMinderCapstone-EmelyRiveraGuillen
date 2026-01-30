import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService{
  //look into the logic more
  static const String _userKey = 'users';

  //This is for register
  static Future<String?> register(User newUser) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_userKey) ?? [];

    for(String u in users){
      User existing = User.fromJson(u);
      if (existing.username == newUser.username ||
          existing.email == newUser.email) {
        return 'Username or email already exists';
      }
    }

    users.add(newUser.toJson());
    await prefs.setStringList(_userKey, users);
    return null;
  }

  //This is for login
  static Future<User?> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_userKey) ?? [];

    for (String u in users) {
      User user = User.fromJson(u);
      if (user.username == username &&
          user.password == password){
        return user;
      }
    }
    return null;
  }
}