import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactAdminScreen extends StatefulWidget {
  ContactAdminScreen({Key key}) : super(key: key);

  @override
  _ContactAdminScreenState createState() => _ContactAdminScreenState();
}

class _ContactAdminScreenState extends State<ContactAdminScreen> {

  _sendMail(email) async {
    // Android and iOS
    String uri = 'mailto:$email';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  _callFunction(String phoneNumber, bool direct) async {
    String url = "tel://$phoneNumber";
    if (direct) {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/trissa_white.png",
          height: 40,
        ),
        backgroundColor: Color(0xff189A95),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16.0),
                child: Text('Contact Admin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black)),
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('Harityas Wiyoga',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black)),
              ),
              Container(
                child: ListTile(
                  onTap: () {
                    _callFunction("+628121185105", true);
                  },
                  leading: Icon(Icons.phone),
                  title: Text('Phone Number'),
                  subtitle: Text('+628121185105'),
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () => _sendMail('harityas.wiyoga@fs-ip.us'),
                  leading: Icon(Icons.email),
                  title: Text('Email Address'),
                  subtitle: Text('harityas.wiyoga@fs-ip.us'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
