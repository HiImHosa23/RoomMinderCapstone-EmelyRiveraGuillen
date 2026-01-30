import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPg extends StatefulWidget {
  const CalendarPg({super.key});

  @override
  State<CalendarPg> createState() => _CalendarPgState();
}

class _CalendarPgState extends State<CalendarPg> {
  DateTime _focusedD = DateTime.now();
  DateTime? _selectD;

  final Map<DateTime, List<String>> events = {};

  List<String> _getEvents(DateTime day){
    final key = DateTime(day.year, day.month, day.day);
    return events[key] ?? [];
  }

  //Add event logic here

  @override
  Widget build(BuildContext context) {
    final eventList =
        _selectD == null ? [] : _getEvents(_selectD!);
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedD,
            selectedDayPredicate: (day) =>
              isSameDay(_selectD, day),
            onDaySelected: (selected, focused){
              setState((){
                _selectD = selected;
                _focusedD = focused;
              });
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(eventList[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
