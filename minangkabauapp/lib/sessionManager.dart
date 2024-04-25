import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  bool? value;
  String? idUser;
  String? namaUser;
  String? email;

  //simpan sesi
  Future<void> saveSession(bool val, String id, String nama, String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("sukses", val);
    pref.setString("id_user", id);
    pref.setString("nama_user", nama);
    pref.setString("email", email);
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    value = pref.getBool("sukses");
    idUser = pref.getString("id_user");
    namaUser = pref.getString("nama_user");
    email = pref.getString("email");
  }

  //remove --> logout
  Future clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

//instance class biar d panggil
SessionManager sessionManager = SessionManager();
