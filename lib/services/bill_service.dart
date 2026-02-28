import 'dart:convert';
import 'package:http/http.dart' as http;

class BillService {
  static const burl = "http://10.0.2.2:5200/bills";
  static Future<void> addTheBill(Map<String, dynamic> bill) async {
    await http.post(
      Uri.parse(burl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(bill),
    );
  }

  static Future<List> getTheBills() async {
    final res = await http.get(
      Uri.parse(burl),
    );
    return jsonDecode(res.body);
  }
}