import 'dart:convert';

DocumentsResponse documentsResponseFromJson(String str) => DocumentsResponse.fromJson(json.decode(str));

String documentsResponseToJson(DocumentsResponse data) => json.encode(data.toJson());

class DocumentsResponse {
  int code;
  String message;
  List<DocumentModels> data;

  DocumentsResponse({
    this.code,
    this.message,
    this.data,
  });

  factory DocumentsResponse.fromJson(Map<String, dynamic> json) => DocumentsResponse(
    code: json["code"],
    message: json["message"],
    data: List<DocumentModels>.from(json["data"].map((x) => DocumentModels.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DocumentModels {
  int idDocument;
  int idUsers;
  String nameDoc;
  String descDoc;
  String ext;
  String file;
  int stDocument;
  DateTime createdAt;
  DateTime updatedAt;

  DocumentModels({
    this.idDocument,
    this.idUsers,
    this.nameDoc,
    this.descDoc,
    this.ext,
    this.file,
    this.stDocument,
    this.createdAt,
    this.updatedAt,
  });

  factory DocumentModels.fromJson(Map<String, dynamic> json) => DocumentModels(
    idDocument: json["id_document"],
    idUsers: json["id_users"],
    nameDoc: json["name_doc"],
    descDoc: json["desc_doc"],
    ext: json["ext"],
    file: json["file"],
    stDocument: json["st_document"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id_document": idDocument,
    "id_users": idUsers,
    "name_doc": nameDoc,
    "desc_doc": descDoc,
    "ext": ext,
    "file": file,
    "st_document": stDocument,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final detailDocumentResponse = detailDocumentResponseFromJson(jsonString);

DetailDocumentResponse detailDocumentResponseFromJson(String str) => DetailDocumentResponse.fromJson(json.decode(str));

String detailDocumentResponseToJson(DetailDocumentResponse data) => json.encode(data.toJson());

class DetailDocumentResponse {
  DetailDocumentResponse({
    this.code,
    this.message,
    this.data,
  });

  int code;
  String message;
  Data data;

  factory DetailDocumentResponse.fromJson(Map<String, dynamic> json) => DetailDocumentResponse(
    code: json["code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.idDocument,
    this.idUsers,
    this.nameDoc,
    this.descDoc,
    this.ext,
    this.file,
    this.stDocument,
    this.createdAt,
    this.updatedAt,
  });

  int idDocument;
  int idUsers;
  String nameDoc;
  String descDoc;
  String ext;
  String file;
  int stDocument;
  DateTime createdAt;
  DateTime updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    idDocument: json["id_document"],
    idUsers: json["id_users"],
    nameDoc: json["name_doc"],
    descDoc: json["desc_doc"],
    ext: json["ext"],
    file: json["file"],
    stDocument: json["st_document"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id_document": idDocument,
    "id_users": idUsers,
    "name_doc": nameDoc,
    "desc_doc": descDoc,
    "ext": ext,
    "file": file,
    "st_document": stDocument,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
