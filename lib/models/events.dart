import 'dart:convert';

class Event {
  String id;
  String title;
  String date;
  String? assignedTo;
  String? type;

  Event({
    required this.id,
    required this.title,
    required this.date,
    this.assignedTo,
    this.type
  });

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      id: json["_id"],
      title: json["title"],
      date: json["date"],
      assignedTo: json["assignedTo"],
      type: json["type"],
    );
  }
}