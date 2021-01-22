import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContactWidget extends StatefulWidget {
  String name;
  int id;
  ContactWidget({this.id, this.name, Key key}) : super(key: key);

  @override
  _ContactWidgetState createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detailContact', arguments: widget.id);
        },
        child: Text(widget.name, style: TextStyle(fontSize: 16, color: Colors.black),),
      ),
    );
  }
}