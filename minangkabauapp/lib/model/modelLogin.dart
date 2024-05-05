// To parse this JSON data, do
//
//     final modelLogin = modelLoginFromJson(jsonString);

import 'dart:convert';

ModelLogin modelLoginFromJson(String str) => ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  bool sukses;
  int status;
  String pesan;
  Data data;

  ModelLogin({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
    sukses: json["sukses"],
    status: json["status"],
    pesan: json["pesan"],
    data: json["data"] != null ? Data.fromJson(json["data"]) : Data(
      idUser: "",
      namaUser: "",
      alamatUser: "",
      nohpUser: "",
      username: "",
      password: "",
    ),
  );

  Map<String, dynamic> toJson() => {
    "sukses": sukses,
    "status": status,
    "pesan": pesan,
    "data": data.toJson(),
  };
}

class Data {
  String idUser;
  String namaUser;
  String alamatUser;
  String nohpUser;
  String username;
  String password;

  Data({
    required this.idUser,
    required this.namaUser,
    required this.alamatUser,
    required this.nohpUser,
    required this.username,
    required this.password,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    idUser: json["id_user"],
    namaUser: json["nama_user"],
    alamatUser: json["alamat_user"],
    nohpUser: json["nohp_user"],
    username: json["username"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id_user": idUser,
    "nama_user": namaUser,
    "alamat_user": alamatUser,
    "nohp_user": nohpUser,
    "username": username,
    "password": password,
  };
}
