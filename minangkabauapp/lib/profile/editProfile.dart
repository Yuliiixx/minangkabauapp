
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/bottomNavBar.dart';
import 'package:minangkabauapp/model/modelBase.dart';
import 'package:minangkabauapp/sessionManager.dart';
import 'package:minangkabauapp/login.dart';
import 'package:minangkabauapp/home/home.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUser();
}

class _EditUser extends State<EditUser> {
  TextEditingController txtNama = TextEditingController(text: '${sessionManager.fullname}');
  TextEditingController txtAlamat = TextEditingController(text: '${sessionManager.alamat}');
  TextEditingController txtNoTelpon = TextEditingController(text: '${sessionManager.nohp}');
  TextEditingController txtUsername = TextEditingController(text: '${sessionManager.userName}');
  TextEditingController txtPassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionManager.getSession();
    sessionManager.getSession().then((value) {
      // logger.d("alamat :: ${sessionManager.alamat}");
      // nama = sessionManager.fullname;
      // username = sessionManager.userName;
      // alamat = sessionManager.alamat;
      // noHp = sessionManager.nohp;
    });
  }

  bool isLoading = false;
  Future<ModelBase?> register() async{
    try{
      isLoading = true;
      // http.Response res = await http.post(Uri.parse('http://192.30.35.126/edukasi/auth.php'),
      http.Response res = await http.post(Uri.parse('${ApiUrl().baseUrl}auth.php'),
        body: {
          "edit_user":"1",
          "id_user" : sessionManager.idUser,
          "username":txtUsername.text,
          "password":txtPassword.text,
          "nama_user":txtNama.text,
          "alamat_user":txtAlamat.text,
          "nohp_user":txtNoTelpon.text
        });
      ModelBase data = modelBaseFromJson(res.body);
      if(data.sukses){
        setState(() {
          isLoading = false;
        });
        sessionManager.saveSession(
            data.sukses,
            sessionManager.idUser as String,
            txtUsername.text,
            txtNama.text,
            txtAlamat.text,
            txtNoTelpon.text
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data.pesan)));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation("profil")),
                (route) => false
        );

    }else{
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data.pesan)));
      }
    }catch(e){
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
        backgroundColor: Color(0xFFF5F9FF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Color(0xFFF5F9FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: txtNama,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: txtAlamat,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: txtNoTelpon,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: txtUsername,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                obscureText: true,
                controller: txtPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk pendaftaran di sini
                register();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900], // Ubah warna tombol di sini
              ),
              child: Text('Edit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
