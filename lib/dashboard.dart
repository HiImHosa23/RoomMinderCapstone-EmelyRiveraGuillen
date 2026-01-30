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
      body: Center(
        child: Text(
          "Welcome, ${user.name}",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
