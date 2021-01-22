import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Timer(
        Duration(seconds: 3),
            () {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
        }
    );
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('Loading...', style: TextStyle(color: Colors.black, fontSize: 16),)
                ],
              ),
              height: 100,
            ),
            contentPadding: EdgeInsets.all(16.0),
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/trissa_white.png", height: 40,),
        backgroundColor: Color(0xff189A95),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text('Settings', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),)
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/faq');
                },
                child: ListTile(
                  leading: Icon(Icons.comment, size: 32,),
                  title: Text('FAQ'),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/aboutApps');
                },
                child: ListTile(
                  leading: Icon(Icons.info, size: 32,),
                  title: Text('About Apps'),
                ),
              ),
              InkWell(
                onTap: () { logout(); },
                child: ListTile(
                  leading: Icon(Icons.power_settings_new, size: 32,),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}