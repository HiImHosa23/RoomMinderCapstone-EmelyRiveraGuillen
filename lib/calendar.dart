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
  void _editEvent(String oldEvent) async{
    TextEditingController controller = TextEditingController(text: oldEvent);

    String? result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Event"),
        content: TextField(controller: controller),
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
    if(result != null && result.isNotEmpty){
      final key = DateTime(
        _selectD!.year,
        _selectD!.month,
        _selectD!.day,
      );
      int index = _events[key]!.indexOf(oldEvent);
      _events[key]![index] = result;
      setState(() {});
    }
  }

  //Add delete event logic here
  void _deleteEvent(String event){
    final key = DateTime(
      _selectD!.year,
      _selectD!.month,
      _selectD!.day,
    );
    _events[key]!.remove(event);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final events = _selectD == null ? [] : _getEventsForDay(_selectD!);
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedD,
            selectedDayPredicate: (day) => isSameDay(_selectD, day),
            onDaySelected: (selected, focused){
              setState(() {
                _selectD = selected;
                _focusedD = focused;
              });
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index){
                final event = events[index];
                return ListTile(
                  title: Text(event),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editEvent(event),//edit event
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteEvent(event),//delete event
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
