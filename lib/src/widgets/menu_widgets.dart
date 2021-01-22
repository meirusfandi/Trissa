import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  String menu_name;
  String menu_icon;
  String menu_link;
  MenuWidget({this.menu_name, this.menu_icon, this.menu_link, Key key}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: 80,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, widget.menu_link);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(widget.menu_icon, height: 60, width: 60,),
              Text(widget.menu_name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),)
            ],
          ),
        ),
    );
  }
}