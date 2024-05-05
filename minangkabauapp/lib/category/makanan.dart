
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/model/modelMakanan.dart';
import 'package:photo_view/photo_view.dart';
import 'package:minangkabauapp/bottomNavBar.dart';

class MakananPage extends StatefulWidget {
  @override
  _MakananPageState createState() => _MakananPageState();
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


class _MakananPageState extends State<MakananPage> {
  Future<List<Datum>?> getMakanan() async {
    // Endpoint API Makanan
    String apiUrl = '${ApiUrl().baseUrl}read.php?data=makanan'; // Ganti dengan URL API yang sesuai
    
    try {
      // Melakukan request HTTP GET ke API
      final response = await http.get(Uri.parse(apiUrl));
      
      // Cek status kode response
      if (response.statusCode == 200) {
        // Parsing data JSON ke dalam objek ModelMakanan menggunakan modelMakananFromJson
        List<Datum> makananList = modelMakananFromJson(response.body).data;
        
        // Mengembalikan data Makanan
        return makananList;
      } else {
        // Jika request gagal, lempar sebuah Exception
        throw Exception('Failed to load makanan');
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
      //     'Makanan Khas Indonesia',
      //     style:
      //         TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
      //   ),
      //   backgroundColor: Colors.blue[900],
      // ),
      body: FutureBuilder<List<Datum>?>(
        future: getMakanan(),
        builder: (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
          // Tampilkan indikator loading jika future belum selesai
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          // Tampilkan pesan jika terjadi error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          // Tampilkan data Makanan jika future selesai
          if (snapshot.hasData && snapshot.data != null) {
            List<Datum> makanan = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: makanan.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ZoomableImage(imageUrl: '${ApiUrl().baseUrl}gambar/makanan/${makanan[index].fotoMakanan}'),
                    ),
                  );
                },child : Image.network(
                  '${ApiUrl().baseUrl}gambar/makanan/${makanan[index].fotoMakanan}',
                  fit: BoxFit.cover,
                ));
              },
            );
          }
          
          // Tampilkan pesan jika tidak ada data Makanan
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
