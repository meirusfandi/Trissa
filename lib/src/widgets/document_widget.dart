import 'package:flutter/material.dart';

class DocumentWidget extends StatefulWidget {

  int idDoc;
  String title;
  String icon;
  String date;

  DocumentWidget({this.idDoc, this.title, this.icon, this.date, Key key}) : super(key: key);

  @override
  _DocumentWidgetState createState() => _DocumentWidgetState();
}

class _DocumentWidgetState extends State<DocumentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.3 - 32,
            child: Image.asset(widget.icon, fit: BoxFit.fitHeight,),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0),
            width: MediaQuery.of(context).size.width * 0.7 - 32,
            child: Wrap(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.7 - 32,
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.left, 
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.black, 
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
                SizedBox(height: 8.0,),

                Text(widget.date, textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Color(0xff189A95)),),
                SizedBox(height: 8.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
//                        Navigator.pushNamed(context, '/news');
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0
                          )
                        ),
                        child: Text('DOWNLOAD', style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ),
                    SizedBox(width: 16,),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/detailDocument', arguments: widget.idDoc);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0
                          )
                        ),
                        child: Text('READ', style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}