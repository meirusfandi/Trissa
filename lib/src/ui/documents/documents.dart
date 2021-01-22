import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/documents_model.dart';
import '../../services/documents_service.dart';

class DocumentScreen extends StatefulWidget {
  DocumentScreen({Key key}) : super(key: key);

  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  TextEditingController _searchDocument = TextEditingController();
  String progressString = "";
  List ext = ["File Type", "PDF", "XLS", "DOCS", "JPEG"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedExt;
  DocumentService _documentService;
  DocumentsResponse documentsResponse;
  List<DocumentModels> docResult = [];
  List<DocumentModels> searchResult = [];
  List<DocumentModels> localResult = [];

  bool isConnect = true;
  bool isWifi = false;
  void checkConnection() async {
    var conn = await (Connectivity().checkConnectivity());
    if (conn == ConnectivityResult.none) {
      if (this.mounted) {
        setState(() {
          isConnect = false;
          isWifi = false;
        });
      }
    } else if (conn == ConnectivityResult.mobile) {
      if (this.mounted) {
        setState(() {
          isConnect = true;
          isWifi = false;
        });
      }
    } else if (conn == ConnectivityResult.wifi) {
      if (this.mounted) {
        setState(() {
          isWifi = true;
          isConnect = false;
        });
      }
    }
  }

  Future<String> get _localFile async {
    final _devicePath = await getApplicationDocumentsDirectory();
    return _devicePath.path;
  }

  String filePath = "";
  String name, exts;
  Future<File> get _files async {
    String _path = await _localFile;
    var newPath = await Directory("$_path/docs").create();
    var newName = name.replaceAll(" ", "_");
    return File("${newPath.path}/$newName.$exts");
  }

  Future downloadFile(url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final file = await _files;
      final _saveFile = await file.writeAsBytes(response.bodyBytes);

      if (this.mounted) {
        setState(() {
          filePath = _saveFile.path;
        });
      }
      downloadFinish();
    } else {
      print(response.statusCode);
    }
  }

  // ignore: missing_return
  Future<DocumentsResponse> getData() async {
    _documentService.getDocument().then((value) {
      if (value != null) {
        documentsResponse = value;
        if (documentsResponse.code == 200) {
          if (this.mounted) {
            setState(() {
              if (!_selectedExt.toLowerCase().contains(ext[0].toString().toLowerCase())) {
                for (DocumentModels models in documentsResponse.data) {
                  if (models.stDocument == 1) {
                    if (_selectedExt.toLowerCase().contains(models.ext.toLowerCase())) {
                      docResult.add(models);
                    }
                  }
                }
              } else {
                for (DocumentModels models in documentsResponse.data) {
                  if (models.stDocument == 1) {
                    docResult.add(models);
                  }
                }
              }
            });
          }
        }
      }
    });
  }

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    if (isConnect || isWifi) {
      docResult.forEach((docs) {
        if (docs.stDocument == 1)
          if (docs.nameDoc.toLowerCase().contains(text.toLowerCase()))
            searchResult.add(docs);
      });
    } else {
      localResult.forEach((docs) {
        if (docs.stDocument == 1)
          if (docs.nameDoc.toLowerCase().contains(text.toLowerCase()))
            searchResult.add(docs);
      });
    }
    setState(() {});
  }

  onExtChange(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      docResult.forEach((docs) {
        if (docs.stDocument == 1)
          if (text.toLowerCase().contains(docs.ext.toLowerCase()))
            searchResult.add(docs);
      });
      setState(() {});
      return;
    }

    docResult.forEach((docs) {
      if (docs.stDocument == 1)
        if (docs.nameDoc.toLowerCase().contains(text.toLowerCase()))
          if (_selectedExt.toLowerCase().contains(docs.ext.toLowerCase()))
            searchResult.add(docs);
    });
    setState(() {});
  }

  downloadFinish() {
    return showDialog(
        context: context,
      builder: (context) => AlertDialog(
        title: Text("Download Completed"),
        actions: <Widget>[
          FlatButton(onPressed: () {OpenFile.open(filePath);}, child: Text("Open File")),
          FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text("Close"))
        ],
      )
    );
  }

  Widget showData(List<DocumentModels> list) {
    String images;
    return ListView.builder(itemCount: list.length, itemBuilder: (context, index) {
      if (list[index].ext.toLowerCase().contains('pdf')) {
        images = 'assets/images/logo_pdf.png';
      } else if (list[index].ext.toLowerCase().contains('xls')) {
        images = 'assets/images/logo_xls.png';
      } else if (list[index].ext.toLowerCase().contains('doc')) {
        images = 'assets/images/logo_docx.png';
      } else {
        images = 'assets/images/logo_docx.png';
      }

      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.3 - 32,
                child: Image.asset(images, fit: BoxFit.fitHeight,),
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
                          list[index].nameDoc,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    SizedBox(height: 8.0,),

                    Text(DateFormat('EEE, MMMM d, ''yyyy').format(list[index].createdAt)+" / "+DateFormat('h:mm a').format(list[index].createdAt), textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Color(0xff189A95)),),
                    SizedBox(height: 8.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            String url = "";
                            if (list[index].file.contains("http")) {
                              url = list[index].file;
                            } else {
                              url = "http://45.130.229.234/trissameirusfandicom/public/uploads/document/${list[index].file}";
                            }
                            setState(() {
                              name = list[index].nameDoc;
                              exts = list[index].ext;
                            });
                            downloadFile(url);
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
                            DocumentModels files = list[index];
                            final data = json.encode(files);
                            Navigator.pushNamed(context, '/detailDocument', arguments: data);
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
              ),
            ],
          ),
          Divider()
        ],
      );
    });
  }

  @override
  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(ext);
    _selectedExt = _dropDownMenuItems[0].value;
    _documentService = DocumentService();
    super.initState();
    checkConnection();
    getData();
    getLocal();
  }

  getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    DocumentsResponse data = documentsResponseFromJson(prefs.getString("documents"));
    if (data.code == 200) {
      for (DocumentModels index in data.data) {
        localResult.add(index);
      }
    }
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List exts) {
    List<DropdownMenuItem<String>> items = List();
    for (String ext in exts) {
      items.add(DropdownMenuItem(value: ext, child: Text(ext)));
    }
    return items;
  }

  void changedDropDownItem(String ext) {
    setState(() {
      _selectedExt = ext;
    });
    // ignore: unnecessary_statements
    onExtChange;
  }

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
            ],
          )
      )
  );

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
                    controller: _searchDocument,
                    decoration: InputDecoration(
                        hintText: 'Search Documents',
                        border: InputBorder.none
                    ),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () {
                    _searchDocument.clear();
                    onSearchTextChanged("");
                  }),
                ),
              )
          ),
          SizedBox(height: 8.0,),

          // documents section
          Expanded(
              child: searchResult.length != 0 || _searchDocument.text.isNotEmpty
                  ? showData(searchResult)
                  : isConnect || isWifi
                    ? FutureBuilder(
                      future: _documentService.getDocument(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            documentsResponse = snapshot.data;
                            docResult = documentsResponse.data;
                            return showData(docResult);
                          } else if (snapshot.hasError) {
                            return showData(localResult);
                          }
                        } else if (snapshot.connectionState == ConnectionState.none) {
                          return showData(localResult);
                        }
                        return showData(localResult);
                      })
                    : showData(localResult)
          )
        ],
      ),
    );
  }
}