import 'dart:async';
import 'dart:convert';

import 'package:cache_image/cache_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/news_model.dart';
import '../../services/news_service.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  TextEditingController _searchNews = TextEditingController();

  NewsService _newsService;
  NewsResponse _newsResponse;
  List<NewsModel> newsResult = [];
  List<NewsModel> searchResult = [];
  List<NewsModel> localResult = [];

  Widget showData(List<NewsModel> list) {
    return ListView.builder(
        itemCount: list.length,
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (list[index].stNews == 1) {
            return Container(
              width: MediaQuery.of(context).size.width,
              color: Color(0xfff1eee9),
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Wrap(
                direction: Axis.vertical,
                children: <Widget>[
                  Container(child: Image(image: CacheImage(list[index].images), fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.75, width: MediaQuery.of(context).size.width - 32,)),
                  SizedBox(height: 8.0,),
                  Container(
                    width: MediaQuery.of(context).size.width - 32,
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text(list[index].title, maxLines: 2, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text(DateFormat('EEE, MMMM d, ''yyyy').format(list[index].createdAt), maxLines: 1, style: TextStyle(fontSize: 10.0, color: Color(0xff189A95)),),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                      width: MediaQuery.of(context).size.width - 32,
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: RichText(
                        text: TextSpan(
                          style: def,
                          children: <TextSpan>[
                            TextSpan(text: _parseHtmlString(list[index].title)+"... "),
                            TextSpan(
                                text: '(READ MORE)',
                                style: read_more,
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  NewsModel files = list[index];
                                  final data = json.encode(files);
                                  Navigator.pushNamed(context, '/detailNews', arguments: data);
                                }
                            )
                          ],
                        ),
                      )
                  ),
                  SizedBox(height: 16.0,)
                ],
              ),
            );
          }
        }
    );
  }

  // ignore: missing_return
  Future<NewsResponse> getData() async {
    _newsService.getNews().then((value) {
      _newsResponse = value;
      if (_newsResponse != null) {
        if (_newsResponse.code == 200) {
          if (this.mounted) {
            setState(() {
              for (NewsModel model in _newsResponse.data) {
                if (model.stNews == 1) {
                  newsResult.add(model);
                }
              }
            });
          }
        }
      }
      return null;
    });
  }

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
    _newsService = NewsService();
    _newsResponse = NewsResponse();
    super.initState();
    checkConnection();
    getData();
    getLocal();
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    NewsResponse data = newsResponseFromJson(prefs.getString("news"));
    if (data.code == 200) {
      for (NewsModel index in data.data) {
        if (index.stNews == 1) {
          localResult.add(index);
        }
      }
    }
  }

  // View to empty data message
  Widget noDataView(String msg) => Center(
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            msg,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8.0,),
        ],
      )
    )
  );

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    if (isConnect || isWifi) {
      newsResult.forEach((news) {
        if (news.stNews == 1)
          if (news.title.toLowerCase().contains(text.toLowerCase()))
            searchResult.add(news);
      });
    } else {
      localResult.forEach((news) {
        if (news.stNews == 1)
          if (news.title.toLowerCase().contains(text.toLowerCase()))
            searchResult.add(news);
      });
    }

    setState(() {});
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    String parseString = parse(document.body.text).documentElement.text;
    return parseString;
  }

  TextStyle def = TextStyle(color: Colors.black, fontSize: 12);
  // ignore: non_constant_identifier_names
  TextStyle read_more = TextStyle(color: Color(0xff189A95), fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff189A95),
        title: Image.asset("assets/images/trissa_white.png", height: 40,)
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextFormField(
                    controller: _searchNews,
                    decoration: InputDecoration(
                        hintText: 'Search News',
                        border: InputBorder.none
                    ),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () {
                    _searchNews.clear();
                    onSearchTextChanged("");
                  }),
                ),
              )
          ),
          Expanded(
            child: searchResult.length != 0 || _searchNews.text.isNotEmpty
                ? showData(searchResult)
                : isConnect || isWifi
                  ? FutureBuilder(
                    future: _newsService.getNews(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          _newsResponse = snapshot.data;
                          newsResult = _newsResponse.data;
                          if (newsResult.length == 0) {
                            return noDataView('No Documents Found');
                          }
                          return showData(newsResult);
                        } else if (snapshot.hasError) {
                          return showData(localResult);
                        }
                      } else if (snapshot.connectionState == ConnectionState.none) {
                        return showData(localResult);
                      }
                      return showData(localResult);
                    },
                  )
                  : showData(localResult)

            )
        ],
      ),
    );
  }
}