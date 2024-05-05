
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/model/modelAlatmusik.dart';
import 'package:minangkabauapp/bottomNavBar.dart';

import 'package:photo_view/photo_view.dart';

class AlatmusikPage extends StatefulWidget {
  @override
  _AlatmusikPageState createState() => _AlatmusikPageState();
}

class ZoomableImage extends StatelessWidget {
  final String imageUrl;

  ZoomableImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black,
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            backgroundDecoration: BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
          ),
        ),
      ),
    );
  }
}


class _AlatmusikPageState extends State<AlatmusikPage> {
  Future<List<Datum>?> getAlatmusik() async {
    // Endpoint API alatmusik
    String apiUrl = '${ApiUrl().baseUrl}read.php?data=alatmusik'; // Ganti dengan URL API yang sesuai
    
    try {
      // Melakukan request HTTP GET ke API
      final response = await http.get(Uri.parse(apiUrl));
      
      // Cek status kode response
      if (response.statusCode == 200) {
        // Parsing data JSON ke dalam objek ModelAlatmusik menggunakan modelAlatmusikFromJson
        List<Datum> alatmusik = modelAlatmusikFromJson(response.body).data;
        
        // Mengembalikan data alatmusik
        return alatmusik;
      } else {
        // Jika request gagal, lempar sebuah Exception
        throw Exception('Failed to load alatmusik');
      }
    } catch (e) {
      // Tangani jika terjadi error
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Alat Musik Adat Indonesia',
      //     style:
      //         TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
      //   ),
      //   backgroundColor: Colors.blue[900],
      // ),
      body: FutureBuilder<List<Datum>?>(
        future: getAlatmusik(),
        builder: (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
          // Tampilkan indikator loading jika future belum selesai
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          // Tampilkan pesan jika terjadi error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          // Tampilkan data alat musik jika future selesai
          if (snapshot.hasData && snapshot.data != null) {
            List<Datum> alatmusik = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: alatmusik.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ZoomableImage(imageUrl: '${ApiUrl().baseUrl}gambar/alat musik/${alatmusik[index].fotoAlatmusik}'),
                    ),
                  );
                },child : Image.network(
                  '${ApiUrl().baseUrl}gambar/alat musik/${alatmusik[index].fotoAlatmusik}',
                  fit: BoxFit.cover,
                ));
              },
            );
          }
          
          // Tampilkan pesan jika tidak ada data alat musik
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
