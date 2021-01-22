import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:intl/intl.dart';
import '../../models/documents_model.dart';
import '../../services/documents_service.dart';

class DetailDocumentScreen extends StatefulWidget {
  DetailDocumentScreen({Key key}) : super(key: key);

  @override
  _DetailDocumentScreenState createState() => _DetailDocumentScreenState();
}

class _DetailDocumentScreenState extends State<DetailDocumentScreen> {

  DocumentService _documentService;
  int idDoc;

  bool isConnect = true;
  bool isWifi = false;
  DocumentModels localDoc;
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
    _documentService = DocumentService();
    super.initState();
    checkConnection();
  }

  // View to empty data message
  Widget noDataView(String msg) => Center(
      child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
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
          )));

  String url;

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments;
    setState(() {
      localDoc = DocumentModels.fromJson(json.decode(data));
      idDoc = localDoc.idDocument;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff189A95),
        title: Image.asset(
          "assets/images/trissa_white.png",
          height: 40,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: isConnect
          ? FutureBuilder(
            future: _documentService.getDetailDocument(idDoc.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DetailDocumentResponse response = snapshot.data;
                  Data data = response.data;
                  if (response.code == 200) {
                    if (data.file.contains("http")) {
                      url = data.file;
                    } else {
                      url =
                      "http://45.130.229.234/trissameirusfandicom/public/uploads/document/${data.file}";
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  data.nameDoc,
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0,),
                                Text(
                                  DateFormat('EEE, MMMM d, ' 'yyyy')
                                      .format(data.createdAt) +
                                      " / " +
                                      DateFormat('h:mm a')
                                          .format(data.createdAt),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ],
                            )
                        ),

                        Expanded(
                          flex: 9,
                          child: PDF().cachedFromUrl(
                            url,
                            placeholder: (progress) => Center(child: Text('$progress %')),
                            errorWidget: (error) => Center(child: Text('Data not found.')),
                          ),
                        )
                      ],
                    );
                  } else {
                    return noDataView(response.message);
                  }
                } else {
                  return noDataView("Loading...");
                }
              }
            )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        localDoc.nameDoc,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0,),
                      Text(
                        DateFormat('EEE, MMMM d, ' 'yyyy')
                            .format(localDoc.createdAt) +
                            " / " +
                            DateFormat('h:mm a')
                                .format(localDoc.createdAt),
                        style: TextStyle(
                            fontSize: 12, color: Colors.black),
                      ),
                    ],
                  )
              ),

              Expanded(
                flex: 9,
                child: PDF().cachedFromUrl(
                  localDoc.file,
                  placeholder: (progress) => Center(child: Text('$progress %')),
                  errorWidget: (error) => Center(child: Text('Data not found.')),
                ),
              )
            ]
        )
      ),
    );
  }
}