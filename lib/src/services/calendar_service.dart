import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/calendar_model.dart';
import 'package:http/http.dart' as http;

class CalendarService {
  String endPoint = 'http://54.251.25.20/api/v1/calendars';
  // String endPoint = 'http://45.130.229.234/trissameirusfandicom/public/api/v1/calendars';
  Future<CalendarResponse> getCalendar() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        endPoint,
        headers: {"X-ApiKey": "9c61f206a3f790ed99001479d34bc1ec8c5fa9c0f2bafad10b2d3b4253ff8c2c"}
      );
      if (response.statusCode == 200) {
        prefs.setString("calendar", response.body);
        Map json = jsonDecode(response.body);
        CalendarResponse result = CalendarResponse.fromJson(json);
        return result;
      } else {
        print('Failed to load calendar data.');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return e;
    }
  }
}