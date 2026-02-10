import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService{
  static const theURL = "http://10.0.2.2:5200";

  //This is for the sign up
  static Future<String?> register(User user) async{
    final response = await http.post(
      Uri.parse("$theURL/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      return null;
    }else{
      return "Registration failed ;-;";
    }
  }

  //This is for login
  static Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$theURL/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if(response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}

//Old authentication service
// class AuthService{
//   //look into the logic more
//   static const String _userKey = 'users';
//
//   //This is for register
//   static Future<String?> register(User newUser) async {
//     // final prefs = await SharedPreferences.getInstance();
//     // List<String> users = prefs.getStringList(_userKey) ?? [];
//     //
//     // for(String u in users){
//     //   User existing = User.fromJson(u);
//     //   if (existing.username == newUser.username ||
//     //       existing.email == newUser.email) {
//     //     return 'Username or email already exists';
//     //   }
//     // }
//
//     // users.add(newUser.toJson());
//     // await prefs.setStringList(_userKey, users);
//   //   return null;
//   // }
//   //
//   // //This is for login
//   // static Future<User?> login(String username, String password) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   List<String> users = prefs.getStringList(_userKey) ?? [];
//   //
//   //   for (String u in users) {
//   //     // User user = User.fromJson(u);
//   //     if (user.username == username &&
//   //         user.password == password){
//   //       return user;
//   //     }
//   //   }
//   //   return null;
//   }
// }
//
//
