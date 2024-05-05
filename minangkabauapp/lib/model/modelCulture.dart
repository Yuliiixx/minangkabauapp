// // // To parse this JSON data, do
// // //
// // //     final modelBerita = modelBeritaFromJson(jsonString);

import 'dart:convert';

ModelCulture modelCultureFromJson(String str) => ModelCulture.fromJson(json.decode(str));

String modelCultureToJson(ModelCulture data) => json.encode(data.toJson());

class ModelCulture {
  bool sukses;
  int status;
  String pesan;
  List<Datum> data;

  ModelCulture({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelCulture.fromJson(Map<String, dynamic> json) => ModelCulture(
    sukses: json["sukses"],
    status: json["status"],
    pesan: json["pesan"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sukses": sukses,
    "status": status,
    "pesan": pesan,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String idCulture;
  String fotoCulture;

  Datum({
    required this.idCulture,
    required this.fotoCulture,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idCulture: json["id_culture"],
    fotoCulture: json["foto_culture"],
  );

  Map<String, dynamic> toJson() => {
    "id_culture": idCulture,
    "foto_culture": fotoCulture,
  };
}
