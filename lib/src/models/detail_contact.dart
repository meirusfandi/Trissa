import 'dart:convert';

import 'package:app_trissa/src/models/contacts_model.dart';

DetailContactsResponse detailContactsResponseFromJson(String str) => DetailContactsResponse.fromJson(json.decode(str));

String detailContactsResponseToJson(DetailContactsResponse data) => json.encode(data.toJson());

class DetailContactsResponse {
  DetailContactsResponse({
    this.code,
    this.message,
    this.data,
  });

  int code;
  String message;
  ContactModels data;

  factory DetailContactsResponse.fromJson(Map<String, dynamic> json) => DetailContactsResponse(
    code: json["code"],
    message: json["message"],
    data: ContactModels.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}