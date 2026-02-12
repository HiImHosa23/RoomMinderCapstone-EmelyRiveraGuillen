import 'package:flutter/material.dart';
import 'package:roommindercapstone/calendar.dart';
import 'package:roommindercapstone/models/user.dart';
import 'package:table_calendar/table_calendar.dart';

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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalendarPg(),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(12),
              child: TableCalendar(
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2030),
                focusedDay: DateTime.now(),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
