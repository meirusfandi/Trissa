import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cache_image/cache_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/calendar_model.dart';
import '../../../../data/models/news_model.dart';
import '../../../../data/services/calendar_service.dart';
import '../../../../data/services/news_service.dart';
import '../../../widgets/menu_widgets.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  var slider = [
    'assets/images/banner_one.jpg',
    'assets/images/banner_two.jpg',
    'assets/images/banner_three.jpg'];
  
  int _current = 0;
  NewsService _newsService;
  CalendarService _calendarService;

  NewsModel newsData;
  CalendarModels calendarData;
  NewsModel localNews;
  CalendarModels localEvents;

  // ignore: missing_return
  Future<NewsResponse> getNewsData() async {
    _newsService.getNews().then((value) {
      if (value != null) {
        if (value.code == 200) {
          if (this.mounted) {
            setState((){
              for (NewsModel index in value.data) {
                newsData = index;
                break;
              }
            });
          }
        }
      }
    });
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('lastNews') != null) {
      final data = prefs.getString('lastNews');
      Map response = jsonDecode(data);
      if (this.mounted) {
        setState(() {
          localNews = NewsModel.fromJson(response);
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          localNews = null;
        });
      }
    }

    if (prefs.getString('lastEvents') != null) {
      final data = prefs.getString('lastEvents');
      Map json = jsonDecode(data);
      int sumOfEvents = 0;
      setState(() {
        localEvents = CalendarModels.fromJson(json);
        DateTime today = DateTime.now();
        int minHours = -100;
        var diff = today.difference(localEvents.waktu).inHours;
        if (diff < 0) {
          if (diff > minHours) {
            minHours = diff;
            sumOfEvents += 1;
          }
        }
        if (sumOfEvents == 0) {
          localNoEvent = true;
        }
      });
    } else {
      setState(() {
        localNoEvent = true;
      });
    }
  }
  bool localNoEvent = false;
  bool noEvent = false;

  // ignore: missing_return
  Future<CalendarResponse> getCalendarData() async {
    _calendarService.getCalendar().then((value) {
      if (value != null) {
        if (value.code == 200) {
          DateTime today = DateTime.now();
          int minHours = -100;
          int sumOfEvents = 0;
          if (this.mounted) {
            setState(() {
              for (CalendarModels index in value.data) {
                var diff = today.difference(index.waktu).inHours;
                if (diff < 0) {
                  if (diff > minHours) {
                    minHours = diff;
                    calendarData = index;
                    sumOfEvents += 1;
                  }
                }
              }
              if (sumOfEvents == 0) {
                noEvent = true;
              }
            });
          }
        }
      }
    });
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

  String appVersion = '1.0.0';
  String oldVersion = '1.0.0';
  bool isRequired = false;
  bool isEnabled = false;
  String url = "https://www.google.com";

  // Future<RemoteConfig> checkVersion() async {
  //   final RemoteConfig remoteConfig = await RemoteConfig.instance;
  //   final defs = <String, dynamic> {'appVersion': '1.0.0'};
  //   await remoteConfig.setDefaults(defs);
  //   await remoteConfig.fetch(expiration: const Duration(hours: 5));
  //   await remoteConfig.activateFetched();
  //   if (this.mounted) {
  //     setState(() {
  //       appVersion = remoteConfig.getString('version');
  //       isEnabled = remoteConfig.getBool('enabled');
  //       isRequired = remoteConfig.getBool('required');
  //       if (Platform.isAndroid) {
  //         url = remoteConfig.getString('url_android');
  //       } else if (Platform.isIOS) {
  //         url = remoteConfig.getString('url_ios');
  //       }
  //     });
  //   }
  //   if (remoteConfig.getBool('enabled')) {
  //     print("enabled update");
  //     if (remoteConfig.getBool('required')) {
  //       print("required");
  //       dialogRequiredUpdate();
  //     } else {
  //       print("not required");
  //       dialogUpdate();
  //     }
  //   }
  //   return remoteConfig;
  // }

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  dialogRequiredUpdate() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Version Available'),
          content: Text("New app version is available. Update your app now!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _launchURL();
              },
              child: Text('Update Now'),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  dialogUpdate() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Version Available'),
          content: Text("New app version is available. Update your app now!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _launchURL();
              },
              child: Text('Update Now'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ignore'),
            ),
          ],
        );
      },
      barrierDismissible: true,
    );
  }

  @override
  void initState() {
    newsData = NewsModel();
    calendarData = CalendarModels();
    _calendarService = CalendarService();
    _newsService = NewsService();
    super.initState();
    checkConnection();
    // checkVersion();
    getNewsData();
    getCalendarData();
    getLocal();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff189A95),
        title: Text('Travelling Staff Smart App', style: TextStyle(color: Colors.white), ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // image slider with carousel
              Wrap(
                children: <Widget>[
                  CarouselSlider(
                    items: slider.map((i) => Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: ClipRRect(
                        // borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(i),
                      ),
                    )).toList(),
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: slider.map((url) {
                      int index = slider.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 8.0,),

              // menu icon
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  MenuWidget(menu_name: 'CONTACTS', menu_icon: 'assets/images/icon_contact.png', menu_link: '/contact',),
                  MenuWidget(menu_name: 'DOCUMENTS', menu_icon: 'assets/images/icon_document.png', menu_link: '/document',),
                  MenuWidget(menu_name: 'CALENDAR', menu_icon: 'assets/images/icon_calendar.png', menu_link: '/calendar',),
                  MenuWidget(menu_name: 'NEWS', menu_icon: 'assets/images/icon_news.png', menu_link: '/news',),
                ],
              ),
              SizedBox(height: 8.0,),

              // upcoming events section
              Container(
                width: MediaQuery.of(context).size.width,
                color: Color(0xfff1eee9),
                padding: EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0, bottom: 16.0),
                child: Wrap(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Upcoming Events',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/calendar');
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    width: 2.0
                                )
                            ),
                            child: Text('See All'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8.0,),
                    isConnect || isWifi
                        ? noEvent
                          ? Center(
                              child: Text('No Upcoming event!', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff189A95),
                                  ),
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                        calendarData.waktu != null ? DateFormat('d').format(calendarData.waktu) : '5',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.0,),
                                Text(
                                      calendarData.waktu != null ? DateFormat('MMM').format(calendarData.waktu) : 'April',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xff189A95),
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                // Spacer(),
                                Icon(Icons.play_arrow),
                                SizedBox(width: 8.0),
                                Container(width: MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      calendarData.notes != null ? calendarData.notes : 'Video Conference with USFS IP STAFF',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                      maxLines: 2,
                                    )
                                )
                              ],
                            )
                        : localNoEvent
                          ? Center(
                              child: Text('No Upcoming event!', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                          )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff189A95),
                                  ),
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                        localEvents.waktu != null ? DateFormat('d').format(localEvents.waktu) : '5',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(width: 8.0,),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                        localEvents.waktu != null ? DateFormat('MMM').format(localEvents.waktu) : 'April',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xff189A95),
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                Icon(Icons.play_arrow),
                                SizedBox(width: 8.0),
                                Container(width: MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                           localEvents.notes != null ? localEvents.notes : 'Video Conference with USFS IP STAFF',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                )
                              ],
                            ),
                  ],
                ),
              ),
              SizedBox(height: 8.0,),

              // news section
              Container(
                width: MediaQuery.of(context).size.width,
                color: Color(0xfff1eee9),
                padding: EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0, bottom: 16.0),
                child: Wrap(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'News',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/news');
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    width: 2.0
                                )
                            ),
                            child: Text('See All'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8.0,),

                    ListTile(
                      leading: Image(
                        image: CacheImage(
                            isConnect || isWifi
                                ? newsData.images != null ? newsData.images : 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Logo_of_the_United_States_Forest_Service.svg/1200px-Logo_of_the_United_States_Forest_Service.svg.png'
                                : localNews.images != null ? localNews.images : 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Logo_of_the_United_States_Forest_Service.svg/1200px-Logo_of_the_United_States_Forest_Service.svg.png'
                        ),
                      ),
                      title: Text(
                        isConnect || isWifi
                            ? newsData.title != null ? newsData.title : 'Bronx zoo tiger tests positive for coronavirus'
                            : localNews.title != null ? localNews.title
                            : 'Bronx zoo tiger tests positive for coronavirus',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 2,
                      ),
                      subtitle: Text(
                        isConnect || isWifi
                            ? newsData.createdAt != null ? DateFormat('EEE, MMMM d, ''yyyy').format(newsData.createdAt) : 'Mon, April 6, 2020'
                            : localNews.createdAt != null ? DateFormat('EEE, MMMM d, ''yyyy').format(localNews.createdAt)
                            : 'Mon, April 6, 2020',
                        style: TextStyle(color: Color(0xff189A95), fontWeight: FontWeight.normal, fontSize: 12),
                        maxLines: 1,
                      ),
                      onTap: () {
                        isConnect || isWifi
                        ? Navigator.pushNamed(context, '/detailNews', arguments: json.encode(newsData))
                        : Navigator.pushNamed(context, '/detailNews', arguments: json.encode(localNews));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}