import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_models.dart';

class LoginService {
  // static String endPoint = 'http://45.130.229.234/trissameirusfandicom/public/api/v1/auth';
  static String endPoint = 'http://54.251.25.20/api/v1/auth';
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    String urlParams = "email=${loginRequest.email}&password=${loginRequest.password}";
    print(urlParams);
    try {
      final response = await http.post(
        endPoint,
        body: urlParams,
        headers: <String, String>{
          "X-ApiKey": "9c61f206a3f790ed99001479d34bc1ec8c5fa9c0f2bafad10b2d3b4253ff8c2c",
          "Content-type": "application/x-www-form-urlencoded"
        }
      );

      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        LoginResponse result = LoginResponse.fromJson(json);
        return result;
      } else {
        print('Failed to load login data.');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}