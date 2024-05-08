import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:minangkabauapp/apiUrl.dart';
import 'package:minangkabauapp/berita/detailBerita.dart';
import 'package:minangkabauapp/model/modelBerita.dart';
import 'package:minangkabauapp/sessionManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var logger = Logger();

  late TextEditingController _searchController;
  late Future<List<Datum>?> _futureBerita;
  List<Datum>? _searchResult;
  late String fullname; // Variabel untuk menyimpan nama pengguna

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureBerita = getBerita();
    sessionManager.getSession().then((_) {
      setState(() {
        // Mendapatkan nama pengguna dari sesi
        // sessionManager.getSession(); 
         fullname = sessionManager.getNama_user() ?? '';
      });
    });
    _searchController.addListener(() {
      searchBerita(_searchController.text);
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFFF5F9FF),
      ),
      backgroundColor: Color(0xFFF5F9FF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Hi, $fullname", // Menampilkan nama pengguna
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              SizedBox(height: 8), // Jarak antara teks dan teks berikutnya
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Welcome to Indonesian Culture!",
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  Center(
                    child: Image.asset("assets/images/gambar1.jpg"),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
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
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder(
                future: _futureBerita,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Datum>?> snapshot) {
                  logger.d("hash data :: ${snapshot.hasData}");
                  if (snapshot.hasData || _searchResult != null) {
                    final data = _searchResult ?? snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                                  builder: (context) =>
                                      PageDetailBerita(dataItem),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors
                                  .white, // Tambahkan ini untuk latar belakang putih
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
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
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
