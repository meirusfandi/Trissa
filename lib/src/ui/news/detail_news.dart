import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import '../../../data/models/news_model.dart';
import '../../../data/services/news_service.dart';
import '../../widgets/detail_news_widget.dart';

class DetailNewsScreen extends StatefulWidget {
  DetailNewsScreen({Key key}) : super(key: key);

  @override
  _DetailNewsScreenState createState() => _DetailNewsScreenState();
}

class _DetailNewsScreenState extends State<DetailNewsScreen> {

  String idNews;

  NewsService _newsService;

  bool isConnect = true;
  bool isWifi = false;
  void checkConnection() async {
    var conn = await (Connectivity().checkConnectivity());
    if (conn == ConnectivityResult.none) {
      setState(() {
        isConnect = false;
        isWifi = false;
      });
    } else if (conn == ConnectivityResult.mobile) {
      setState(() {
        isConnect = true;
        isWifi = false;
      });
    } else if (conn == ConnectivityResult.wifi) {
      setState(() {
        isWifi = true;
        isConnect = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _newsService = NewsService();
    super.initState();
    checkConnection();
  }

  // View to empty data message
  Widget noDataView(String msg) => Center(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white,
          ),
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
  NewsModel localData;

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments;
    setState(() {
      localData = NewsModel.fromJson(json.decode(data));
      idNews = localData.idNews.toString();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff189A95),
        title: Image.asset("assets/images/trissa_white.png", height: 40,)
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 16.0),
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Text('News', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),)),
              SizedBox(height: 16.0,),
              Container(
                child: isConnect
                    ? FutureBuilder(
                    future: _newsService.getDetailNews(idNews),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        NewsDetailResponse response = snapshot.data;
                        DetailNews data = response.data;
                        if (response.code == 200) {
                          return DetailNewsWidget(
                            idNews: data.idNews,
                            idUsers: data.idUsers,
                            title: data.title,
                            slug: data.slug,
                            images: data.images,
                            shortContent: data.shortContent,
                            content: data.content,
                            source: data.source,
                            hits: data.hits,
                            stNews: data.stNews,
                            createdAt: data.createdAt,
                            updatedAt: data.updatedAt,
                          );
                        } else {
                          return noDataView(response.message);
                        }
                      } else {
                        return noDataView("Loading...");
                      }
                    })
                    : DetailNewsWidget(
                        idNews: localData.idNews,
                        idUsers: localData.idUsers,
                        title: localData.title,
                        slug: localData.slug,
                        images: localData.images,
                        shortContent: localData.shortContent,
                        content: localData.content,
                        source: localData.source,
                        hits: localData.hits,
                        stNews: localData.stNews,
                        createdAt: localData.createdAt,
                        updatedAt: localData.updatedAt,
                      )
              ),
            ],
          ),
        ),
      ),
    );
  }
}