import 'dart:convert';

class User{
  final String name;
  final String username;
  final String email;
  final String password;

  User({
    required this.name,
    required this.username,
    required this.email,
    required this.password
  });

//  create a map
  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map){
    return User(
      name: map['name'],
      username: map['username'],
      email: map['email'],
      password: map['password']
    );
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source));
}