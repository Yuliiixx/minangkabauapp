// // // To parse this JSON data, do
// // //
// // //     final modelBerita = modelBeritaFromJson(jsonString);

import 'dart:convert';

ModelAlatmusik modelAlatmusikFromJson(String str) => ModelAlatmusik.fromJson(json.decode(str));

String modelAlatmusikToJson(ModelAlatmusik data) => json.encode(data.toJson());

class ModelAlatmusik {
  bool sukses;
  int status;
  String pesan;
  List<Datum> data;

  ModelAlatmusik({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelAlatmusik.fromJson(Map<String, dynamic> json) => ModelAlatmusik(
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
  String idAlatmusik;
  String fotoAlatmusik;

  Datum({
    required this.idAlatmusik,
    required this.fotoAlatmusik,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idAlatmusik: json["id_alatmusik"],
    fotoAlatmusik: json["foto_alatmusik"],
  );

  Map<String, dynamic> toJson() => {
    "id_alatmusik": idAlatmusik,
    "foto_alatmusik": fotoAlatmusik,
  };
}
