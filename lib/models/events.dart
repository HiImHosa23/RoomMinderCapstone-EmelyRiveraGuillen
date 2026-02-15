import 'dart:convert';

class Event {
  String id;
  String title;
  String date;

  Event({
    required this.id,
    required this.title,
    required this.date,
  });

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      id: json["_id"],
      title: json["title"],
      date: json["date"],
    );
  }
}