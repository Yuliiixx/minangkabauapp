
import 'dart:convert';

ModelPahlawan modelPahlawanFromJson(String str) => ModelPahlawan.fromJson(json.decode(str));

String modelPahlawanToJson(ModelPahlawan data) => json.encode(data.toJson());

class ModelPahlawan {
  bool sukses;
  int status;
  String pesan;
  List<Datum> data;

  ModelPahlawan({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelPahlawan.fromJson(Map<String, dynamic> json) => ModelPahlawan(
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
  String idPahlawan;
    String nama;
    String foto;
    DateTime tanggalLahir;
    String asal;
    String jenisKelamin;
    String deskripsi;

  Datum({
    required this.idPahlawan,
        required this.nama,
        required this.foto,
        required this.tanggalLahir,
        required this.asal,
        required this.jenisKelamin,
        required this.deskripsi,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
     idPahlawan: json["id_pahlawan"],
        nama: json["nama"],
        foto: json["foto"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        asal: json["asal"],
        jenisKelamin: json["jenis_kelamin"],
        deskripsi: json["deskripsi"],
  );

  get namaPahlawan => null;

  get fotoPahlawan => null;

  Map<String, dynamic> toJson() => {
   "id_pahlawan": idPahlawan,
        "nama": nama,
        "foto": foto,
        "tanggal_lahir": "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "asal": asal,
        "jenis_kelamin": jenisKelamin,
        "deskripsi": deskripsi,
  };
}