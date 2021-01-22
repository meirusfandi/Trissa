import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';

import 'package:http/http.dart';

class DetailCalendarScreen extends StatefulWidget {
  DetailCalendarScreen({Key key}) : super(key: key);

  @override
  _DetailCalendarScreenState createState() => _DetailCalendarScreenState();
}

class _DetailCalendarScreenState extends State<DetailCalendarScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<RootResponse> getData() async {
    Response response = await get('https://reqres.in/api/users/1');
    if (response.statusCode == 200)
      return rootResponseFromJson(response.body);
    else
      throw Exception('error code: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff189A95),
        title: Image.asset("assets/images/trissa_white.png", height: 40,),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<RootResponse>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            RootResponse rootResponse = snapshot.data;
            if (snapshot.hasData)
              return Center(
                child: Column(
                  children: <Widget>[
                    Text(rootResponse.data.email),
                    Text(rootResponse.data.firstName),
                    Text(rootResponse.data.lastName),
                    Image.network("rootResponse.data.avatar", height: 100, width: 100, fit: BoxFit.cover,),
                  ],
                ),
              );
            else
              return CircularProgressIndicator();
          },
        ),
      )
    );
  }
}

RootResponse rootResponseFromJson(String str) =>
    RootResponse.fromJson(json.decode(str));
String rootResponseToJson(RootResponse data) =>
    json.encode(data.toJson());
class RootResponse {
  Data data;
  RootResponse({
    this.data,
  });
  factory RootResponse.fromJson(Map<String, dynamic> json) =>
      RootResponse(

        data: Data.fromJson(json["data"]),
      );
  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;
  Data({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],

    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    avatar: json["avatar"],
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "avatar": avatar,
  };
}