import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/documents_model.dart';

class DocumentService {
  String endPoint = 'http://54.251.25.20/api/v1/documents';
  // String endPoint = 'http://45.130.229.234/trissameirusfandicom/public/api/v1/documents';

  Future<DocumentsResponse> getDocument() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        endPoint,
        headers: {"X-ApiKey": "9c61f206a3f790ed99001479d34bc1ec8c5fa9c0f2bafad10b2d3b4253ff8c2c"}
      );
      if (response.statusCode == 200) {
        prefs.setString("documents", response.body);
        Map json = jsonDecode(response.body);

        DocumentsResponse result = DocumentsResponse.fromJson(json);
        return result;
      } else {
        print('Failed to load documents data.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String detailDocumentUrl = 'http://54.251.25.20/api/v1/document/';
  // String detailDocumentUrl = 'http://45.130.229.234/trissameirusfandicom/public/api/v1/document/';
  // ignore: missing_return
  Future<DetailDocumentResponse> getDetailDocument(String idDoc) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        detailDocumentUrl+idDoc,
        headers: {"X-ApiKey": "9c61f206a3f790ed99001479d34bc1ec8c5fa9c0f2bafad10b2d3b4253ff8c2c"}
      );
      if (response.statusCode == 200) {
        prefs.setString("document_"+idDoc, response.body);
        Map json = jsonDecode(response.body);
        DetailDocumentResponse result = DetailDocumentResponse.fromJson(json);
        return result;
      } else {
        print('Failed to load documents data.');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}