import 'package:flutter/material.dart';
import 'package:roommindercapstone/models/user.dart';
import 'package:roommindercapstone/dashboard.dart';
import 'package:roommindercapstone/bill_splitter.dart';
import 'package:roommindercapstone/calendar.dart';
import 'package:roommindercapstone/chore_assigner.dart';
import 'package:roommindercapstone/profile.dart';

class MainNavPg extends StatefulWidget {
  final User user;
  const MainNavPg({super.key, required this.user});

  @override
  State<MainNavPg> createState() => _MainNavPgState();
}

class _MainNavPgState extends State<MainNavPg> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  @override
  void initState(){
    super.initState();

    _pages = [
      DashboardPg(user: widget.user),
      ChorePg(user: widget.user),
      BillPg(user: widget.user),
      CalendarPg(user: widget.user),
    ];
  }

  void _onTap(int index){
    setState(() {
      _selectedIndex = index;
      _pages = [
        DashboardPg(user: widget.user),
        ChorePg(user: widget.user),
        BillPg(user: widget.user),
        CalendarPg(user: widget.user),
      ];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "RoomMinder",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.home_rounded,
            ),
          ],
        ),
        backgroundColor: Color(0xFF4FAF9F),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context, MaterialPageRoute(
                  builder: (_) => ProfilePg(user: widget.user),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Color(0xFF4FAF9F),
                ),
              ),
            ),
          )
        ],
      ),
      body: [
        DashboardPg(user: widget.user),
        ChorePg(user: widget.user),
        BillPg(user: widget.user),
        CalendarPg(user: widget.user),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,

        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF4FAF9F),
        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: "Chores",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "Bills",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
        ],
      ),
    );
  }
}
