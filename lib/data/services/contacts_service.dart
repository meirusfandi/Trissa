import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contacts_model.dart';
import '../models/detail_contact.dart';

class ContactService {
  String endPoint = 'http://54.251.25.20/api/v1/contacts';
  // String endPoint = 'http://45.130.229.234/trissameirusfandicom/public/api/v1/contacts';
  Future<ContactsResponse> getContact() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        endPoint,
        headers: {"X-ApiKey": "9c61f206a3f790ed99001479d34bc1ec8c5fa9c0f2bafad10b2d3b4253ff8c2c"}
      );
      if (response.statusCode == 200) {
        prefs.setString("contacts", response.body);
        Map json = jsonDecode(response.body);
        ContactsResponse result = ContactsResponse.fromJson(json);
        return result;
      } else {
        print('Failed to load contacts data.');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<DetailContactsResponse> getDetailContact(String idContact) async {
    // String detailContactsUrl = 'http://45.130.229.234/trissameirusfandicom/public/api/v1/contact/';
    String detailContactsUrl = 'http://54.251.25.20/api/v1/contact/';
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        detailContactsUrl+idContact,
        headers: {"X-ApiKey": "9c61f206a3f790ed99001479d34bc1ec8c5fa9c0f2bafad10b2d3b4253ff8c2c"}
      );
      if (response.statusCode == 200) {
        prefs.setString("contact_"+idContact, response.body);
        Map json = jsonDecode(response.body);
        DetailContactsResponse result = DetailContactsResponse.fromJson(json);
        return result;
      } else {
        print('Failed to load contacts data.');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}