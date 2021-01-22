import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(
            seconds: 2
        ), () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
    );
    return Scaffold(
      backgroundColor: Color(0xfff1eee9),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Container(
                  child: Image.asset('assets/images/logofix.png', height: 200, width: 200,),
                ),
              ),
            ),
            Positioned(
              bottom: 32.0,
              right: 32.0,
              left: 32.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color(0xff189A95),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: MaterialButton(
                  onPressed: () {
                  },
                  child: Text('GET STARTED', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white
                    ),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}