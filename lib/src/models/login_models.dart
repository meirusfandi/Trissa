import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.code,
    this.message,
    this.data,
  });

  int code;
  String message;
  LoginModel data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    code: json["code"],
    message: json["message"],
    data: LoginModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class LoginModel {
  LoginModel({
    this.id,
    this.name,
    this.email,
    this.apiToken,
    this.type,
    this.stUser,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String email;
  String apiToken;
  String type;
  int stUser;
  DateTime createdAt;
  DateTime updatedAt;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    apiToken: json["api_token"],
    type: json["type"],
    stUser: json["st_user"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "api_token": apiToken,
    "type": type,
    "st_user": stUser,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}


class LoginRequest {
  String email;
  String password;

  LoginRequest({this.email, this.password});
}