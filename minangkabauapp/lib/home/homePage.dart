import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/berita/detailBerita.dart';
import 'package:minangkabauapp/model/modelBerita.dart';
import 'package:minangkabauapp/model/modelLogin.dart';
import 'package:minangkabauapp/sessionManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var logger = Logger();

  String? userName;
  late TextEditingController _searchController;
  late Future<List<Datum>?> _futureBerita;
  List<Datum>? _searchResult;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureBerita = getBerita();
    _searchController.addListener(() {
      searchBerita(_searchController.text);
    });
    // getUserName(); // Panggil fungsi untuk mengambil nama pengguna
  }

  Future<List<Datum>?> getBerita() async {
    try {
      http.Response res =
          await http.get(Uri.parse('${ApiUrl().baseUrl}read.php?data=berita'));
      logger.d("data di dapat :: ${modelBeritaFromJson(res.body).data}");
      return modelBeritaFromJson(res.body).data;
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Future<void> getUser() async {
    try {
      http.Response res =
          await http.get(Uri.parse('${ApiUrl().baseUrl}auth.php'));
      var namaUser = jsonDecode(res.body);
      setState(() {
        userName = namaUser['nama_user'];
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Future<void> searchBerita(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResult = null;
      });
      return;
    }
    List<Datum>? berita = await getBerita();
    if (berita != null) {
      List<Datum> result = berita
          .where((datum) =>
              datum.judulBerita!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        _searchResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dataItem;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Text(
              '${sessionManager.fullname}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "What Would you like to learn Today? \nSearch Below.",
              style: TextStyle(color: Colors.grey[500]),
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                Center(
                  child: Image.asset("assets/images/sld_1.png"),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Widget lain di sini jika diperlukan
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari berita...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchBerita('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _futureBerita,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Datum>?> snapshot) {
                  logger.d("hash data :: ${snapshot.hasData}");
                  if (snapshot.hasData || _searchResult != null) {
                    final data = _searchResult ?? snapshot.data;
                    return ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        Datum? dataItem = data?[index];
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PageDetailBerita(dataItem),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            '${ApiUrl().baseUrl}gambar/berita/${dataItem?.gambarBerita}',
                                            width: 150,
                                            height: 100,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ), // Jarak antara gambar dan teks
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${dataItem?.judulBerita}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ), // Jarak antara judul dan subtitle
                                              Text(
                                                "${dataItem?.kontenBerita}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
