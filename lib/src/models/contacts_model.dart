import 'dart:convert';

ContactsResponse contactsResponseFromJson(String str) => ContactsResponse.fromJson(json.decode(str));

String contactsResponseToJson(ContactsResponse data) => json.encode(data.toJson());

class ContactsResponse {
  ContactsResponse({
    this.code,
    this.message,
    this.data,
  });

  int code;
  String message;
  List<ContactModels> data;

  factory ContactsResponse.fromJson(Map<String, dynamic> json) => ContactsResponse(
    code: json["code"],
    message: json["message"],
    data: List<ContactModels>.from(json["data"].map((x) => ContactModels.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ContactModels {
  ContactModels({
    this.idContact,
    this.idUsers,
    this.firstName,
    this.lastName,
    this.images,
    this.location,
    this.division,
    this.dateOfBirth,
    this.email,
    this.otherEmail,
    this.phone,
    this.address,
    this.fsPhone,
    this.otherPhone,
    this.stContact,
    // this.createdAt,
    // this.updatedAt,
  });

  int idContact;
  int idUsers;
  String firstName;
  String lastName;
  String images;
  String location;
  String division;
  String dateOfBirth;
  String email;
  String otherEmail;
  String phone;
  String address;
  String fsPhone;
  String otherPhone;
  int stContact;
  // DateTime createdAt;
  // DateTime updatedAt;

  factory ContactModels.fromJson(Map<String, dynamic> json) => ContactModels(
    idContact: json["id_contact"],
    idUsers: json["id_users"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    images: json["images"],
    location: json["location"],
    division: json["division"],
    dateOfBirth: json["date_of_birth"],
    email: json["email"],
    otherEmail: json["other_email"],
    phone: json["phone"],
    address: json["address"],
    fsPhone: json["fs_phone"],
    otherPhone: json["other_phone"],
    stContact: json["st_contact"],
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id_contact": idContact,
    "id_users": idUsers,
    "first_name": firstName,
    "last_name": lastName,
    "images": images,
    "location": location,
    "division": division,
    "date_of_birth": dateOfBirth,
    "email": email,
    "other_email": otherEmail,
    "phone": phone,
    "address": address,
    "fs_phone": fsPhone,
    "other_phone": otherPhone,
    "st_contact": stContact,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
  };
}
