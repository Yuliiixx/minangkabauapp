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
      email: "",
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
  String email;
  String password;

  Data({
    required this.idUser,
    required this.namaUser,
    required this.email,
    required this.password,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    idUser: json["id_user"],
    namaUser: json["nama_user"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id_user": idUser,
    "nama_user": namaUser,
    "email": email,
    "password": password,
  };
}
