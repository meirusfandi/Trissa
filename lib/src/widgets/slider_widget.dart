import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  SliderWidget({Key key}) : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width - 64,
        child: Stack(
          children: <Widget>[
            Image.asset('assets/images/icon_home.png')
          ],
        ),
      ),
    );
  }
}