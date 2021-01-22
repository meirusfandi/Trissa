import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class NewsService {
  // String endPoint = 'http://45.130.229.234/trissameirusfandicom/public/api/v1/news';
  String endPoint = 'http://54.251.25.20/api/v1/news';
  Future<NewsResponse> getNews() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        endPoint,
        headers: {"X-ApiKey": "9c61f206a3f790ed99001479d34bc1ec8c5fa9c0f2bafad10b2d3b4253ff8c2c"}
      );
      if (response.statusCode == 200) {
        prefs.setString("news", response.body);
        Map json = jsonDecode(response.body);
        NewsResponse result = NewsResponse.fromJson(json);

        return result;
      } else {
        print('Failed to load news data.');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<NewsDetailResponse> getDetailNews(String id) async {
    String newsDetailUrl = 'http://54.251.25.20/api/v1/news/' + id;
    // String newsDetailUrl = 'http://45.130.229.234/trissameirusfandicom/public/api/v1/news/' + id;
    try {
      final response = await http.get(
        newsDetailUrl,
        headers: {"X-ApiKey": "9c61f206a3f790ed99001479d34bc1ec8c5fa9c0f2bafad10b2d3b4253ff8c2c"}
      );
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        NewsDetailResponse result = NewsDetailResponse.fromJson(json);
        return result;
      } else {
        print('Failed to load news data.');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}