import 'dart:convert';

class Event {
  String id;
  String title;
  String date;
  String userId;
  String? assignedTo;
  String? type;
  String? priority;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.userId,
    this.assignedTo,
    this.type,
    this.priority
  });

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      id: json["_id"],
      title: json["title"],
      date: json["date"],
      userId: json["userId"],
      assignedTo: json["assignedTo"],
      type: json["type"],
      priority: json["priority"],
    );
  }
}