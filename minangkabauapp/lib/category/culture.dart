
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/model/modelCulture.dart';
import 'package:photo_view/photo_view.dart';
import 'package:minangkabauapp/bottomNavBar.dart';

class CulturePage extends StatefulWidget {
  @override
  _CulturePageState createState() => _CulturePageState();
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


class _CulturePageState extends State<CulturePage> {
  Future<List<Datum>?> getCulture() async {
    // Endpoint API Culture
    String apiUrl = '${ApiUrl().baseUrl}read.php?data=culture'; // Ganti dengan URL API yang sesuai
    
    try {
      // Melakukan request HTTP GET ke API
      final response = await http.get(Uri.parse(apiUrl));
      
      // Cek status kode response
      if (response.statusCode == 200) {
        // Parsing data JSON ke dalam objek ModelCulture menggunakan modelCultureFromJson
        List<Datum> cultureList = modelCultureFromJson(response.body).data;
        
        // Mengembalikan data Culture
        return cultureList;
      } else {
        // Jika request gagal, lempar sebuah Exception
        throw Exception('Failed to load culture');
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
      //     'Culture Indonesia',
      //     style:
      //         TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
      //   ),
      //   backgroundColor: Colors.blue[900],
      // ),
      body: FutureBuilder<List<Datum>?>(
        future: getCulture(),
        builder: (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
          // Tampilkan indikator loading jika future belum selesai
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          // Tampilkan pesan jika terjadi error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          // Tampilkan data Culture jika future selesai
          if (snapshot.hasData && snapshot.data != null) {
            List<Datum> culture = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: culture.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ZoomableImage(imageUrl: '${ApiUrl().baseUrl}gambar/culture/${culture[index].fotoCulture}'),
                    ),
                  );
                },child : Image.network(
                  '${ApiUrl().baseUrl}gambar/culture/${culture[index].fotoCulture}',
                  fit: BoxFit.cover,
                ));
              },
            );
          }
          
          // Tampilkan pesan jika tidak ada data Culture
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
