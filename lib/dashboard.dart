import 'package:flutter/material.dart';
import 'package:roommindercapstone/bill_splitter.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Welcome ${widget.user.name}",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                _navigateAndRefresh(
                  ChorePg(user: widget.user),
                );
              },
              child: Text("Chore Assigner"),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BillPg(user: widget.user),
                  ),
                );
              },
              child: Text("Bill Splitter"),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                _navigateAndRefresh(
                  CalendarPg(user: widget.user),
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
            ),
            SizedBox(height: 20),
            //Figure out a better way to display T^T
            // FutureBuilder<List<Event>>(
            //   future: _eventsFuture,
            //   builder: (context, snapshot){
            //     if(!snapshot.hasData){
            //       return CircularProgressIndicator();
            //     }
            //     final events = snapshot.data!;
            //     final today = DateTime.now();
            //     final todaysEvents = events.where((event) {
            //       final eventDate = DateTime.parse(event.date);
            //       return eventDate.year == today.year &&
            //           eventDate.month == today.month &&
            //           eventDate.day == today.day;
            //     }).toList();
            //     return Card(
            //       margin: EdgeInsets.symmetric(
            //         horizontal: 16,
            //         vertical: 10
            //       ),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             "Today",
            //             style: TextStyle(
            //               fontSize: 18,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           SizedBox(height: 8),
            //           if (todaysEvents.isEmpty)
            //             const Text("No events today 🎉")
            //           else
            //             ...todaysEvents.map((event) => Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 2),
            //               child: Text(
            //                 event.type == "chore"
            //                     ? "• ${event.title} (${event.priority ?? "No priority"})"
            //                     : "• ${event.title}",
            //                 style: const TextStyle(fontSize: 14),
            //               ),
            //             )),
            //         ],
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
