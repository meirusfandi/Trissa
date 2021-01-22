import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:toast/toast.dart';
import '../../models/contacts_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/detail_contact.dart';
import '../../services/contacts_service.dart';

class DetailContactScreen extends StatefulWidget {
  DetailContactScreen({Key key}) : super(key: key);

  @override
  _DetailContactScreenState createState() => _DetailContactScreenState();
}

class _DetailContactScreenState extends State<DetailContactScreen> {

  ContactService _contactService;
  String userId;

  bool isConnect = true;
  bool isWifi = false;
  void checkConnection() async {
    var conn = await (Connectivity().checkConnectivity());
    if (conn == ConnectivityResult.none) {
      setState(() {
        isConnect = false;
        isWifi = false;
      });
    } else if (conn == ConnectivityResult.mobile) {
      setState(() {
        isConnect = true;
        isWifi = false;
      });
    } else if (conn == ConnectivityResult.wifi) {
      setState(() {
        isWifi = true;
        isConnect = false;
      });
    }
  }

  @override
  void initState() {
    _contactService = ContactService();
    super.initState();
    checkConnection();
  }

  DetailContactsResponse _detailContactsResponse;

  Future<Null> _refresh() {
    return _contactService.getDetailContact(userId).then((value) {
      setState(() => _detailContactsResponse = value);
    });
  }

  Widget showData(ContactModels data, String defImages, String defName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Images section
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 16.0),
            height: MediaQuery.of(context).size.height * 0.25 - 16,
            width: MediaQuery.of(context).size.height * 0.25 - 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
            child: Align(alignment: Alignment.center, child: Text(defImages, style: TextStyle(fontSize: 48, color: Colors.black, fontWeight: FontWeight.bold),)),
          ),
        ),
        SizedBox(height: 32.0,),

        // name section
        Container(width: MediaQuery.of(context).size.width - 64, margin: EdgeInsets.only(left: 16.0, right: 16.0), child: Text(defName, textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 32.0),)),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          width: MediaQuery.of(context).size.width - 32,
          child: Divider(
            height: 4,
            thickness: 2,
          ),
        ),

        // work phone section
        ListTile(
          onTap: () {
            if (data.phone != null) {
              if (data.phone.length > 0) {
                _callFunction(data.phone, true);
              } else {
                showMessage("Phone Number Not Found!");
              }
            } else {
              showMessage("Phone Number Not Found!");
            }
          },
          title: Text('Work Phone', style: TextStyle(fontSize: 12, color: Colors.black),),
          subtitle: Text(data.phone != null ? data.phone: '', style: TextStyle(fontSize: 16, color: Colors.black),),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          width: MediaQuery.of(context).size.width - 32,
          child: Divider(
            height: 4,
            thickness: 2,
          ),
        ),

        // email section
        ListTile(
          onTap: () {
            if (data.email != null) {
              if (data.email.length > 0) {
                _sendMail(data.email);
              } else {
                showMessage("Email Address Not Found!");
              }
            } else {
              showMessage("Email Address Not Found!");
            }
          },
          title: Text('Email', style: TextStyle(fontSize: 12, color: Colors.black),),
          subtitle: Text(data.email != null ? data.email: '', style: TextStyle(fontSize: 16, color: Colors.black),),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          width: MediaQuery.of(context).size.width - 32,
          child: Divider(
            height: 4,
            thickness: 2,
          ),
        ),

        // FS Cell Phone section
        ListTile(
          onTap: () {
            if (data.fsPhone != null) {
              if (data.fsPhone.length > 0) {
                _callFunction(data.fsPhone, true);
              } else {
                showMessage("Phone Number Not Found!");
              }
            } else {
              showMessage("Phone Number Not Found!");
            }
          },
          title: Text('FS Cell Phone', style: TextStyle(fontSize: 12, color: Colors.black),),
          subtitle: Text(data.fsPhone != null ? data.fsPhone: '', style: TextStyle(fontSize: 16, color: Colors.black),),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          width: MediaQuery.of(context).size.width - 32,
          child: Divider(
            height: 4,
            thickness: 2,
          ),
        ),

        // Other Phone Section
        ListTile(
          onTap: () {
            if (data.otherPhone != null) {
              if (data.otherPhone.length > 0) {
                _callFunction(data.otherPhone, true);
              } else {
                showMessage("Phone Number Not Found!");
              }
            } else {
              showMessage("Phone Number Not Found!");
            }
          },
          title: Text('Other Phone', style: TextStyle(fontSize: 12, color: Colors.black),),
          subtitle: Text(data.otherPhone != null ? data.otherPhone: '', style: TextStyle(fontSize: 16, color: Colors.black),),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          width: MediaQuery.of(context).size.width - 32,
          child: Divider(
            height: 4,
            thickness: 2,
          ),
        ),

        // Other email section
        ListTile(
          onTap: () {
            if (data.otherEmail != null) {
              if (data.otherEmail.length > 0) {
                _sendMail(data.otherEmail);
              } else {
                showMessage("Email Address Not Found!");
              }
            } else {
              showMessage("Email Address Not Found!");
            }
          },
          title: Text('Other Email', style: TextStyle(fontSize: 12, color: Colors.black),),
          subtitle: Text(data.otherEmail != null ? data.otherEmail: '', style: TextStyle(fontSize: 16, color: Colors.black),),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0),
          width: MediaQuery.of(context).size.width - 32,
          child: Divider(
            height: 4,
            thickness: 2,
          ),
        ),
      ],
    );
  }

  _sendMail(email) async {
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

  // View to empty data message
  Widget noDataView(String msg) => Center(
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                msg,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8.0,),
              InkWell(
                child: Icon(Icons.refresh, color: Colors.orange,),
                onTap: () {
                  _refresh();
                },
              )
            ],
          )
      )
  );
  String defNama;
  String defGambar;
  ContactModels contact;

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments;
    setState(() {
      contact = ContactModels.fromJson(json.decode(data));
      userId = contact.idContact.toString();

      if (contact.lastName.isEmpty && contact.firstName.isEmpty) {
        defNama = "-";
        defGambar = "JD";
      } else {
        defNama = contact.lastName+", "+contact.firstName;
        defGambar = contact.firstName[0] + contact.lastName[0];
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff189A95),
        title: Image.asset("assets/images/trissa_white.png", height: 40,),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: isConnect || isWifi
                ? FutureBuilder(
                    future: _contactService.getDetailContact(userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String defName;
                        String defImages;
                        _detailContactsResponse = snapshot.data;
                        if (_detailContactsResponse.data.lastName.isEmpty && _detailContactsResponse.data.firstName.isEmpty) {
                          defName = "-";
                          defImages = "JD";
                        } else {
                          defName = _detailContactsResponse.data.lastName+", "+_detailContactsResponse.data.firstName;
                          defImages = _detailContactsResponse.data.firstName[0] + _detailContactsResponse.data.lastName[0];
                        }
                        return showData(_detailContactsResponse.data, defImages, defName);
                      } else if (snapshot.hasError) {
                        return noDataView(snapshot.error);
                      } else {
                        return noDataView("Loading...");
                      }
                    },
                  )
                : showData(contact, defGambar, defNama)
        ),
      ),
    );
  }

  void showMessage(msg)
  {
    Toast.show(msg, context, gravity: Toast.BOTTOM);
  }
}