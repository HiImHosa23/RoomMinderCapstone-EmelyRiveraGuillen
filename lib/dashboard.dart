import 'package:flutter/material.dart';
import 'package:roommindercapstone/models/user.dart';

class DashboardPg extends StatelessWidget {
  final User user;
  const DashboardPg({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Welcome, ${user.name}",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          //Display Calendar
        ],
      ),
    );
  }
}
