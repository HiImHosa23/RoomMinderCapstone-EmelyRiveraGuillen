import '../models/events.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  static const evUrl = "http://10.0.2.2:5200/events";

  static Future<List<Event>> getEvents(String userId) async {
    final response = await http.get(
      Uri.parse("$evUrl/$userId")
    );

    final data = jsonDecode(response.body);
    return List<Event>.from(
      data.map((e) => Event.fromJson(e))
    );
  }

  static Future<void> addEvent(String title, String date, String userId) async{
    await http.post(
      Uri.parse(evUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "date": date,
        "userId": userId
      }),
    );
  }

  static Future<void> deleteEvent(String id) async{
    await http.delete(Uri.parse("$evUrl/$id"));
  }

  static Future<void> updateEvent(String id, String title, String date) async{
    await http.put(
      Uri.parse("$evUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "date": date
      })
    );
  }
}