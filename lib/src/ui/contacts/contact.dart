import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/contacts_model.dart';
import '../../../data/services/contacts_service.dart';

class ContactScreen extends StatefulWidget {
  ContactScreen({Key key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  TextEditingController _searchContact = TextEditingController();
  ContactService _contactService;
  String defChar;
  ContactsResponse contactsResponse;
  List<ContactModels> localData = [];
  ContactsResponse _contactsResponse;
  List<ContactModels> _searchResult = [];
  List<ContactModels> _contactResults = [];

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

  getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    ContactsResponse data = contactsResponseFromJson(prefs.getString("contacts"));
    if (data.code == 200) {
      for (ContactModels index in data.data) {
        if (index.stContact == 1) {
          localData.add(index);
        }
      }
    }
  }

  Widget showData(List<ContactModels> list) {
    return ListView.builder(
        itemCount: list.length,
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (list[index].stContact == 1) {
            String current = list[index].lastName[0].toUpperCase();
            if (defChar == current) {
              return Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(""),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: InkWell(
                      onTap: () {
                        ContactModels files = list[index];
                        final data = json.encode(files);
                        Navigator.pushNamed(context, '/detailContact', arguments: data);
                      },
                      child: Text(list[index].lastName+", "+list[index].firstName, style: TextStyle(fontSize: 24, color: Colors.black),),
                    ),
                  )
                ],
              );
            } else {
              defChar = current;
              return Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(defChar, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, color: Colors.black)),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: InkWell(
                      onTap: () {
                        ContactModels files = list[index];
                        final data = json.encode(files);
                        Navigator.pushNamed(context, '/detailContact', arguments: data);
                      },
                      child: Text(list[index].lastName+", "+list[index].firstName, style: TextStyle(fontSize: 24, color: Colors.black),),
                    ),
                  )
                ],
              );
            }
          }
        }
    );
  }

  @override
  void initState() {
    defChar = "";
    _contactsResponse = ContactsResponse();
    _contactService = ContactService();
    super.initState();
    checkConnection();
    getContacts();
    getLocal();
  }

  // ignore: missing_return
  Future<ContactsResponse> getContacts() async {
    _contactService.getContact().then((value) {
      _contactsResponse = value;
      if (_contactsResponse != null) {
        if (_contactsResponse.code == 200) {
          if (this.mounted) {
            setState(() {
              for (ContactModels contact in _contactsResponse.data) {
                _contactResults.add(contact);
              }
            });
          }
        }
      }
    });
  }

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
            ],
          )
      )
  );

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    if (isConnect || isWifi) {
      _contactResults.forEach((contacts) {
        if (contacts.stContact == 1)
          if (contacts.lastName.toLowerCase().contains(text.toLowerCase()) || contacts.firstName.toLowerCase().contains(text.toLowerCase()))
            _searchResult.add(contacts);
      });
    } else {
      localData.forEach((contacts) {
        if (contacts.stContact == 1)
          if (contacts.lastName.toLowerCase().contains(text.toLowerCase()) || contacts.firstName.toLowerCase().contains(text.toLowerCase()))
            _searchResult.add(contacts);
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff189A95),
          title: Image.asset("assets/images/trissa_white.png", height: 40,)
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextFormField(
                    controller: _searchContact,
                    decoration: InputDecoration(
                        hintText: 'Search Contacts',
                        border: InputBorder.none
                    ),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () {
                    _searchContact.clear();
                    onSearchTextChanged("");
                  }),
                ),
              )
          ),
          Expanded(
              child: _searchResult.length != 0 || _searchContact.text.isNotEmpty
                  ? showData(_searchResult)
                  : isConnect || isWifi
                  ? FutureBuilder(
                future: _contactService.getContact(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      contactsResponse = snapshot.data;
                      _contactResults = contactsResponse.data;
                      return showData(_contactResults);
                    } if (snapshot.hasError) {
                      return showData(localData);
                    }
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return showData(localData);
                  }
                  return showData(localData);
                },
              )
                  : showData(localData)
          ),
        ],
      ),
    );
  }
}