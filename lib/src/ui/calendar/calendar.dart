import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../data/services/calendar_service.dart';
import '../../../data/models/calendar_model.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin {

  Map<DateTime, List> eventsDays = {};
  CalendarService _calendarService;
  CalendarResponse calendarResponse;
  CalendarController _calendarController;
  AnimationController _animationController;
  CalendarResponse _localResponse;
  List _selectedEvents;
  DateTime _selectedDay;

  Future<Map<DateTime, List>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final response = prefs.getString("calendar");
    Map json = jsonDecode(response);
    _localResponse = CalendarResponse.fromJson(json);

    Map<DateTime, List> mapFetch = {};
    _calendarService.getCalendar().then((value) {
      if (value != null) {
        calendarResponse = value;
        if (calendarResponse.code == 200) {
          if (this.mounted) {
            setState(() {
              for (CalendarModels calendar in calendarResponse.data) {
                int year = int.parse(DateFormat('yyyy').format(calendar.waktu));
                int month = int.parse(DateFormat('MM').format(calendar.waktu));
                int day = int.parse(DateFormat('dd').format(calendar.waktu));
                DateTime waktu = DateTime(year, month, day);
                var original = mapFetch[waktu];
                Note notes;
                String result;
                if (original == null) {
                  notes = Note(days: DateFormat('EEE').format(calendar.waktu), dates: DateFormat('d').format(calendar.waktu), note: calendar.notes, times: DateFormat("H:mm a").format(calendar.waktu));
                  result = noteToJSON(notes);
                  mapFetch[waktu] = [result];
                } else {
                  notes = Note(days: DateFormat('EEE').format(calendar.waktu), dates: DateFormat('d').format(calendar.waktu), note: calendar.notes, times: DateFormat("H:mm a").format(calendar.waktu));
                  result = noteToJSON(notes);
                  mapFetch[waktu] = List.from(original)
                    ..addAll([result]);
                }
              }
            });
          }
        }
      }
    });
    return mapFetch;
  }

  bool isConnect = true;
  bool isWifi = false;
  void checkConnection() async {
    var conn = await (Connectivity().checkConnectivity());
    if (conn == ConnectivityResult.none) {
      if (this.mounted) {
        setState(() {
          isConnect = false;
          isWifi = false;
        });
      }
    } else if (conn == ConnectivityResult.mobile) {
      if (this.mounted) {
        setState(() {
          isConnect = true;
          isWifi = false;
        });
      }
    } else if (conn == ConnectivityResult.wifi) {
      if (this.mounted) {
        setState(() {
          isWifi = true;
          isConnect = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _calendarService = CalendarService();
    calendarResponse = CalendarResponse();
    _localResponse = CalendarResponse();
    _selectedDay = DateTime.now();
    _selectedEvents = eventsDays[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData().then((val) => setState(() {
        eventsDays = val;
      }));
    });
    checkConnection();
    super.initState();
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      calendarController: _calendarController,
      events: eventsDays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.deepOrange[300],
                shape: BoxShape.circle
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(fontWeight: FontWeight.bold).copyWith(fontSize: 16.0),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Colors.amber[400],
                shape: BoxShape.circle
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(fontWeight: FontWeight.bold).copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events, _) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    if (this.mounted) {
      setState(() {
        _selectedEvents = events;
      });
    }
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
            ? Colors.brown[300]
            : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents.map((event) {
        final data = noteFromJSON(event);
        DateTime today = DateTime.now();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(width: MediaQuery.of(context).size.width * 0.2, child: Text(data.days, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 14),)),
                    Container(width: MediaQuery.of(context).size.width * 0.2, child: Text(data.dates, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20),)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: ListTile(
                  title: Text(data.note),
                  subtitle: Text(data.times),
                  trailing: today.difference(data.dateTime).inDays > 0 ? Container() : Icon(Icons.check, color: Colors.green,),
                  onTap: () {
                    print('tapped!');
                  },
                ),
              ),
            ],
          ),
        );
      }).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff189A95),
        title: Image.asset("assets/images/trissa_white.png", height: 40,)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }
}

Note noteFromJSON(String str) => Note.fromJSON(json.decode(str));
String noteToJSON(Note data) => json.encode(data.toJSON());

class Note {
  String days;
  String dates;
  String note;
  String times;
  DateTime dateTime;

  Note({this.days, this.dates, this.note, this.times, this.dateTime});

  factory Note.fromJSON(Map<String, dynamic> json) => Note(
    days: json["days"] != null ? json["days"] : "Tue",
    dates: json["dates"] != null ? json["dates"] : "1",
    note: json["note"] != null ? json["note"] : "Testing Notes",
    times: json["times"] != null ? json["times"] : "11:00 AM",
    dateTime: json["date"] != null ? json["date"] : DateTime.now()
  );

  Map<String, dynamic> toJSON() => {
    "days": days,
    "dates": dates,
    "note": note,
    "times": times,
    "date": dateTime
  };
}