// // // To parse this JSON data, do
// // //
// // //     final modelBerita = modelBeritaFromJson(jsonString);

import 'dart:convert';

ModelPakaian modelPakaianFromJson(String str) => ModelPakaian.fromJson(json.decode(str));

String modelPakaianToJson(ModelPakaian data) => json.encode(data.toJson());

class ModelPakaian {
  bool sukses;
  int status;
  String pesan;
  List<Datum> data;

  ModelPakaian({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelPakaian.fromJson(Map<String, dynamic> json) => ModelPakaian(
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
  String idPakaian;
  String fotoPakaian;

  Datum({
    required this.idPakaian,
    required this.fotoPakaian,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idPakaian: json["id_pakaian"],
    fotoPakaian: json["foto_pakaian"],
  );

  Map<String, dynamic> toJson() => {
    "id_pakaian": idPakaian,
    "foto_pakaian": fotoPakaian,
  };
}
