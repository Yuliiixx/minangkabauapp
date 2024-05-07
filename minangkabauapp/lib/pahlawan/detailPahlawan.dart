import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/bottomNavBar.dart';
import 'package:minangkabauapp/model/modelPahlawan.dart';
import 'package:minangkabauapp/pahlawan/editPahlawan.dart';
import 'package:http/http.dart' as http;

class DetailPahlawan extends StatelessWidget {
  final Datum? data;

  const DetailPahlawan(this.data, {Key? key}) : super(key: key);

  Future<void> _hapusDataPahlawan(context) async {
    final String apiUrl = '${ApiUrl().baseUrl}pahlawan.php';

    final response = await http.post(Uri.parse(apiUrl), body: {
      'id_pahlawan': data?.idPahlawan,
      'action': "hapus",
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data pahlawan berhasil dihapus')),
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation("pahlawan")),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data pahlawan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data!.nama ?? 'Detail Pahlawan',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[900],
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPahlawan("1", data),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.white,
            onPressed: () {
              var logger = Logger();
              logger.d("id Pahlawan :: ${data?.idPahlawan}");
              _hapusDataPahlawan(context);
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F9FF),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '${ApiUrl().baseUrl}${data?.foto}',
                      // '${ApiUrl().baseUrl}gambar/pahlawan/${data?.foto}',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    '${data?.nama ?? ""}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  // key: Key('judul_nama'),
                ),
                // ListTile(
                //   title: Text(
                //     'Foto: ${data?.foto ?? ""}',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 14,
                //     ),
                //   ),
                //   // key: Key('judul_foto'),
                // ),
                ListTile(
                  title: Text(
                    'Jenis kelamin: ${data?.jenisKelamin ?? ""}',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  // key: Key('judul_jenis_kelamin'),
                ),
                ListTile(
                  title: Text(
                    'Asal: ${data?.asal ?? ""}',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  // key: Key('judul_asal'),
                ),
                ListTile(
                  title: Text(
                    'Tanggal Lahir: ${data?.tanggalLahir ?? ""}',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  // key: Key('judul_tanggal_lahir'),
                ),
                ListTile(
                  title: Text(
                    ' ${data?.deskripsi ?? ""}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  // key: Key('judul_tanggal_lahir'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
