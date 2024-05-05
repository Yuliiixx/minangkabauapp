// // // To parse this JSON data, do
// // //
// // //     final modelBerita = modelBeritaFromJson(jsonString);

import 'dart:convert';

ModelMakanan modelMakananFromJson(String str) => ModelMakanan.fromJson(json.decode(str));

String modelMakananToJson(ModelMakanan data) => json.encode(data.toJson());

class ModelMakanan {
  bool sukses;
  int status;
  String pesan;
  List<Datum> data;

  ModelMakanan({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelMakanan.fromJson(Map<String, dynamic> json) => ModelMakanan(
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
  String idMakanan;
  String fotoMakanan;

  Datum({
    required this.idMakanan,
    required this.fotoMakanan,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idMakanan: json["id_makanan"],
    fotoMakanan: json["foto_makanan"],
  );

  Map<String, dynamic> toJson() => {
    "id_makanan": idMakanan,
    "foto_makanan": fotoMakanan,
  };
}
