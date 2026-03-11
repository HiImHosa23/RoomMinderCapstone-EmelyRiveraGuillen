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
        backgroundColor: Color(0xFF4FAF9F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4FAF9F),
        onPressed: _addEvent,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TableCalendar(
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
                    ),
                    weekendTextStyle: TextStyle(
                      color: Color(0xFF4FAF9F),
                    ),
                  ),
                  eventLoader: _getEventsForDay,
                ),
              ),
            ),
          ),
          if(_selectD != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                DateFormat.yMMMMd().format(_selectD!),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4FAF9F),
                ),
              ),
            ),
          SizedBox(height: 10),
          Expanded(
            child: events.isEmpty ? Center(
              child: Text(
                "No events here!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ) : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index){
                final event = events[index];

                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      event.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Color(0xFF4FAF9F),
                          ),
                          onPressed: () => _editEvent(event),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _deleteEvent(event),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          )
        ],
      ),
    );
  }
}
