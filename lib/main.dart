import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/ui/aboutapps/aboutapps.dart';
import 'src/ui/faq/faq.dart';
import 'src/models/calendar_model.dart';
import 'src/models/contacts_model.dart';
import 'src/models/documents_model.dart';
import 'src/models/news_model.dart';
import 'src/services/calendar_service.dart';
import 'src/services/contacts_service.dart';
import 'src/services/documents_service.dart';
import 'src/services/news_service.dart';
import 'src/ui/calendar/calendar.dart';
import 'src/ui/calendar/detail_calendar.dart';
import 'src/ui/contacts/contact.dart';
import 'src/ui/contacts/detail_contact.dart';
import 'src/ui/documents/detail_document.dart';
import 'src/ui/documents/documents.dart';
import 'src/ui/home/contact_admin/contact_admin.dart';
import 'src/ui/home/dashboard/dashboard.dart';
import 'src/ui/home/home.dart';
import 'src/ui/home/settings/settings.dart';
import 'src/ui/login/login.dart';
import 'src/ui/news/detail_news.dart';
import 'src/ui/news/news.dart';
import 'src/ui/splash/splash.dart';

//void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(),
      routes: <String, WidgetBuilder> {
        '/splash': (BuildContext context) => SplashScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/home': (BuildContext context) => HomeScreen(),
        '/dashboard': (BuildContext context) => DashboardScreen(),
        '/contact_admin': (BuildContext context) => ContactAdminScreen(),
        '/settings': (BuildContext context) => SettingScreen(),
        '/contact': (BuildContext context) => ContactScreen(),
        '/news': (BuildContext context) => NewsScreen(),
        '/document': (BuildContext context) => DocumentScreen(),
        '/calendar': (BuildContext context) => CalendarScreen(),
        '/detailNews': (BuildContext context) => DetailNewsScreen(),
        '/detailDocument': (BuildContext context) => DetailDocumentScreen(),
        '/detailCalendar': (BuildContext context) => DetailCalendarScreen(),
        '/detailContact': (BuildContext context) => DetailContactScreen(),
        '/aboutApps': (BuildContext context) => AboutAppsScreen(),
        '/faq': (BuildContext context) => FaqScreen()
      },
    );
  }
}

class MainApp extends StatefulWidget {

  MainApp({Key key}) : super(key: key);
  @override
  _MainAppState createState() => _MainAppState();

}

class _MainAppState extends State<MainApp> {

  checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogin') != null) {
      if (prefs.getBool('isLogin') == true) {
        Navigator.pushNamedAndRemoveUntil(context, '/splash', (r) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
    }
  }

  NewsService _newsService;
  CalendarService _calendarService;
  ContactService _contactService;
  DocumentService _documentService;

  createCache() async {
    final prefs = await SharedPreferences.getInstance();
    _newsService.getNews().then((value) {
      if (value != null) {
        if (value.code == 200) {
          final data = newsResponseToJson(value);
          prefs.setString('news', data);
          for (NewsModel index in value.data) {
            final data = json.encode(index);
            prefs.setString('lastNews', data);
            break;
          }
        }
      }
    });

    _contactService.getContact().then((value) {
      if (value != null) {
        if (value.code == 200) {
          final data = contactsResponseToJson(value);
          prefs.setString('contacts', data);
        }
      }
    });

    _documentService.getDocument().then((value) {
      if (value != null) {
        if (value.code == 200) {
          final data = documentsResponseToJson(value);
          prefs.setString('documents', data);
        }
      }
    });

    _calendarService.getCalendar().then((value) {
      if (value != null) {
        if (value.code == 200) {
          final data = calendarResponseToJson(value);
          prefs.setString('calendars', data);
          DateTime today = DateTime.now();
          int minHours = -100;
          if (this.mounted) {
            setState(() {
              for (CalendarModels index in value.data) {
                var diff = today.difference(index.waktu).inHours;
                if (diff < 0) {
                  if (diff > minHours) {
                    minHours = diff;
                    final data = json.encode(index);
                    prefs.setString('lastEvents', data);
                  }
                }
              }
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _newsService = NewsService();
    _calendarService = CalendarService();
    _documentService = DocumentService();
    _contactService = ContactService();
    checkLogin();
    createCache();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Loading ...'),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}