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

  final Map<DateTime, List<String>> _events = {};

  List<String> _getEventsForDay(DateTime day){
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  //Add event logic here
  void _addEvent() async{
    if(_selectD == null) return;
    TextEditingController controller = TextEditingController();

    String? result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Event"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter event name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text("Save"),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty){
      final key = DateTime(
        _selectD!.year,
        _selectD!.month,
        _selectD!.day,
      );
      _events.putIfAbsent(key, () => []);
      _events[key]!.add(result);

      setState(() {});
    }
  }

  //Add edit event logic here

  //Add delete event logic here

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
    );
  }
}
