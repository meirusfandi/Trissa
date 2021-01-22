import 'package:flutter/material.dart';

class AboutAppsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/trissa_white.png", height: 40,),
        backgroundColor: Color(0xff189A95),
      ),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width,
              child: Text('About Apps', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),)
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Trissa is a platform to provide access to reference documents needed for the traveling staff, support technical coordination between the traveling staff and in-country staff, and provide information related to in-country context, health and safety information for the traveling staff.'
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text('Features: file sharing, contact management, news articles.'),
          ),
        ],
      ),
    );
  }

}