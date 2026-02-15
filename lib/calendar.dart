import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:roommindercapstone/models/user.dart';
import 'package:roommindercapstone/services/ev_service.dart';
import 'package:roommindercapstone/models/events.dart';
import 'package:intl/intl.dart';


class CalendarPg extends StatefulWidget {
  final User user;
  const CalendarPg({super.key, required this.user});

  @override
  State<CalendarPg> createState() => _CalendarPgState();
}

class _CalendarPgState extends State<CalendarPg> {
  DateTime _focusedD = DateTime.now();
  DateTime? _selectD;

  Map<DateTime, List<Event>> _events = {};

  @override
  void initState(){
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await EventService.getEvents(widget.user.id!);
    Map<DateTime, List<Event>> grouped = {};
    for(var event in events){
      DateTime date = DateTime.parse(event.date);
      Text(DateFormat('yyyy-MM-dd').format(date));
      final key = DateTime(date.year, date.month, date.day);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(event);
    }
    setState(() {
      _events = grouped;
    });
  }

  List<Event> _getEventsForDay(DateTime day){
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
      // final key = DateTime(
      //   _selectD!.year,
      //   _selectD!.month,
      //   _selectD!.day,
      // );
      // _events.putIfAbsent(key, () => []);
      // _events[key]!.add(result);
      //
      // setState(() {});
      await EventService.addEvent(
        result,
        _selectD!.toIso8601String(),
        widget.user.id!
      );
      _loadEvents();
    }
  }

  //Add edit event logic here
  void _editEvent(Event event) async{
    TextEditingController controller = TextEditingController(text: event.title);

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
      // final key = DateTime(
      //   _selectD!.year,
      //   _selectD!.month,
      //   _selectD!.day,
      // );
      // int index = _events[key]!.indexOf(oldEvent);
      // _events[key]![index] = result;
      // setState(() {});
      await EventService.updateEvent(
        event.id,
        result,
        event.date,
      );
      _loadEvents();
    }
  }

  //Add delete event logic here
  void _deleteEvent(Event event) async{
    // final key = DateTime(
    //   _selectD!.year,
    //   _selectD!.month,
    //   _selectD!.day,
    // );
    // _events[key]!.remove(event);
    // setState(() {});
    await EventService.deleteEvent(event.id);
    _loadEvents();
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
                  title: Text(event.title),
                  // subtitle: Text(DateFormat.yMMMd().format(DateTime.parse(event.date))),
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
