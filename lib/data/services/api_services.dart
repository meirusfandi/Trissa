import 'package:app_trissa/data/models/calendar_model.dart';
import 'package:app_trissa/data/models/contacts_model.dart';
import 'package:app_trissa/data/models/detail_contact.dart';
import 'package:app_trissa/data/models/documents_model.dart';
import 'package:app_trissa/data/models/login_models.dart';
import 'package:app_trissa/data/models/news_model.dart';

class ApiServices {
  String baseUrl = "http://54.251.25.20/api/v1/";

  Future<CalendarResponse> serviceCalendar() async {

  }

  Future<ContactsResponse> serviceContact() async {

  }

  Future<DetailContactsResponse> serviceDetailContact(String contactID) async {

  }

  // news services
  Future<NewsResponse> serviceNews() async {

  }

  Future<NewsDetailResponse> serviceDetailNews(String newsId) async {

  }

  // document services
  Future<DocumentsResponse> serviceDocument() async {

  }

  Future<DetailDocumentResponse> serviceDetailDocuments(String documentsId) {

  }

  // login services
  Future<LoginResponse> serviceLogin(String username, String password) async {

  }
}