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
  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password']
    );
  }
}