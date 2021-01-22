import 'package:cache_image/cache_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

// ignore: must_be_immutable
class NewsWidget extends StatefulWidget {
  String data;
  String images;
  String title;
  String dates;
  String desc;
  int idNews;
  NewsWidget({this.data, this.images, this.title, this.dates, this.desc, this.idNews, Key key}) : super(key: key);

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {


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
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xfff1eee9),
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(child: Image(image: CacheImage(widget.images), fit: BoxFit.fill, height: MediaQuery.of(context).size.width * 0.75, width: MediaQuery.of(context).size.width - 32,)),
          SizedBox(height: 8.0,),
          Container(
            width: MediaQuery.of(context).size.width - 32,
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(widget.title, maxLines: 2, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(widget.dates, maxLines: 1, style: TextStyle(fontSize: 10.0, color: Color(0xff189A95)),),
          ),
          SizedBox(height: 8.0),
          Container(
            width: MediaQuery.of(context).size.width - 32,
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: RichText(
              text: TextSpan(
                style: def,
                children: <TextSpan>[
                  TextSpan(text: _parseHtmlString(widget.title)+"... "),
                  TextSpan(
                    text: '(READ MORE)', 
                    style: read_more, 
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.pushNamed(context, '/detailNews', arguments: widget.data);
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