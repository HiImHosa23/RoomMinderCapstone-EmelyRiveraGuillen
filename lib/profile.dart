import 'package:flutter/material.dart';
import 'package:roommindercapstone/models/user.dart';
import 'package:roommindercapstone/login.dart';

class ProfilePg extends StatelessWidget {
  final User user;
  const ProfilePg({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
            SizedBox(height: 20),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(),
                  ),
                    (route) => false,
                );
              },
              child: Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}
