import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class DetailNewsWidget extends StatefulWidget {

  int idNews;
  int idUsers;
  String title;
  String slug;
  String images;
  String shortContent;
  String content;
  String source;
  int hits;
  int stNews;
  DateTime createdAt;
  DateTime updatedAt;

  DetailNewsWidget({this.idNews, this.idUsers, this.title, this.slug, this.images, this.shortContent, this.content, this.source, this.hits, this.stNews, this.createdAt, this.updatedAt});
  @override
  _DetailNewsWidgetState createState() => _DetailNewsWidgetState();
}

class _DetailNewsWidgetState extends State<DetailNewsWidget> {

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    String parseString = parse(document.body.text).documentElement.text;
    return parseString;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Text(DateFormat('EEE, MMMM d, ''yyyy').format(widget.createdAt)+" / "+DateFormat('h:mm a').format(widget.createdAt), textAlign: TextAlign.right, maxLines: 1, style: TextStyle(fontSize: 12.0, color: Colors.black),),
        ),
        SizedBox(height: 8.0,),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Image(
                height: MediaQuery.of(context).size.width * 0.75,
                width: MediaQuery.of(context).size.width - 32,
                fit: BoxFit.fill,
                image: CacheImage(widget.images),
              ),
              SizedBox(height: 16.0,),
              Container(
                width: MediaQuery.of(context).size.width - 32,
                child: Text(widget.title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 4.0,),
              Container(
                width: MediaQuery.of(context).size.width - 32,
                child: Text('Source : '+(widget.source.isNotEmpty ? widget.source : "-"), softWrap: true, maxLines: 5, style: TextStyle(fontSize: 12.0),),
              ),
              SizedBox(height: 16.0,),
              Container(
                width: MediaQuery.of(context).size.width - 32,
                padding: EdgeInsets.all(8.0),
                child: Text(_parseHtmlString(widget.content), textAlign: TextAlign.justify,),
              ),
              SizedBox(height: 16.0,)
            ],
          ),
        ),
      ],
    );
  }
}
