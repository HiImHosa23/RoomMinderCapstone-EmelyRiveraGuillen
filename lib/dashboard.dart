import 'package:flutter/material.dart';
// import 'package:roommindercapstone/bill_splitter.dart';
import 'package:roommindercapstone/calendar.dart';
import 'package:roommindercapstone/chore_assigner.dart';
import 'package:roommindercapstone/models/user.dart';
import 'package:roommindercapstone/models/events.dart';
import 'package:roommindercapstone/services/ev_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:roommindercapstone/bill_splitter.dart';

class DashboardPg extends StatefulWidget {
  final User user;
  const DashboardPg({
    super.key,
    required this.user,
  });

  @override
  State<DashboardPg> createState() => _DashboardPgState();
}

class _DashboardPgState extends State<DashboardPg> {
  late Future<List<Event>> _eventsFuture;
  @override
  void initState(){
    super.initState();
    _loadEvents();
  }
  void _loadEvents(){
    _eventsFuture = EventService.getEvents(widget.user.id!);
  }

  Future<void> _navigateAndRefresh(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    setState(() {
      _loadEvents();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF3F8F7),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: Color(0xFF4FAF9F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Text(
                "Welcome ${widget.user.name}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: (){
              _navigateAndRefresh(
                CalendarPg(user: widget.user),
              );
            },
            child: Card(
              elevation: 6,
              margin: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020),
                  lastDay: DateTime.utc(2030),
                  focusedDay: DateTime.now(),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color(0xFF4FAF9F),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF4FAF9F),
                      shape: BoxShape.circle,
                    )
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


}
