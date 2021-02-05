import 'dart:convert';

CalendarResponse calendarResponseFromJson(String str) => CalendarResponse.fromJson(json.decode(str));

String calendarResponseToJson(CalendarResponse data) => json.encode(data.toJson());

class CalendarResponse {
  int code;
  String message;
  List<CalendarModels> data;

  CalendarResponse({
    this.code,
    this.message,
    this.data,
  });

  factory CalendarResponse.fromJson(Map<String, dynamic> json) => CalendarResponse(
    code: json["code"],
    message: json["message"],
    data: List<CalendarModels>.from(json["data"].map((x) => CalendarModels.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CalendarModels {
  int idCalendar;
  int idUsers;
  DateTime waktu;
  String notes;
  int stCalendar;
  DateTime createdAt;
  DateTime updatedAt;

  CalendarModels({
    this.idCalendar,
    this.idUsers,
    this.waktu,
    this.notes,
    this.stCalendar,
    this.createdAt,
    this.updatedAt,
  });

  factory CalendarModels.fromJson(Map<String, dynamic> json) => CalendarModels(
    idCalendar: json["id_calendar"],
    idUsers: json["id_users"],
    waktu: DateTime.parse(json["waktu"]),
    notes: json["notes"],
    stCalendar: json["st_calendar"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id_calendar": idCalendar,
    "id_users": idUsers,
    "waktu": waktu.toIso8601String(),
    "notes": notes,
    "st_calendar": stCalendar,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
