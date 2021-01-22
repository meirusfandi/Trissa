import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/trissa_white.png", height: 40,),
        backgroundColor: Color(0xff189A95),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Container(
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width,
              child: Text('FAQ', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),)
          ),
          ListTile(
            title: Text('What is Trissa and how does it work?', style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text('Trissa is a platform that lets you manage documents and contacts related to your work. Trissa gives you the flexibility to access your document and connect with your colleagues from anywhere with an internet connection. Trissa is hosted on cloud-based servers and available for Apple iOS and Android OS.\n\nCurrently Trissa is on beta version.'),
          ),
          ListTile(
            title: Text('How do I get an account ?', style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text('Please reach out to the administrator at: trissasmart@gmail.com'),
          ),
          ListTile(
            title: Text('I have problem accessing the app, who should I call ?', style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text('Please reach out to the administrator at: trissasmart@gmail.com'),
          ),
        ],
      ),
    );
  }
}