// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// import 'package:minangkabauapp/apiUrl.dart';
// import 'package:minangkabauapp/berita/detailBerita.dart';
// import 'package:minangkabauapp/model/modelBerita.dart';

// class WidgetListBerita extends StatefulWidget {
//   const WidgetListBerita({super.key});

//   @override
//   State<WidgetListBerita> createState() => _WidgetListBeritaState();
// }

// class _WidgetListBeritaState extends State<WidgetListBerita> {
//   var logger = Logger();

//   String? userName;
//   // late TextEditingController _searchController;
//   late Future<List<Datum>?> _futureBerita;
//   // List<Datum>? _searchResult;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _searchController = TextEditingController();
//   //   _futureBerita = getBerita();
//   //   _searchController.addListener(() {
//   //     searchBerita(_searchController.text);
//   //   });
//   // }

//   Future<List<Datum>?> getBerita() async {
//     try {
//       http.Response res =
//           await http.get(Uri.parse('${ApiUrl().baseUrl}read.php?data=berita'));
//       logger.d("data di dapat :: ${modelBeritaFromJson(res.body).data}");
//       return modelBeritaFromJson(res.body).data;
//     } catch (e) {
//       setState(() {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(e.toString())));
//       });
//     }
//   }

//   // Future<void> searchBerita(String query) async {
//   //   if (query.isEmpty) {
//   //     setState(() {
//   //       _searchResult = null;
//   //     });
//   //     return;
//   //   }
//   //   List<Datum>? berita = await getBerita();
//   //   if (berita != null) {
//   //     List<Datum> result = berita
//   //         .where((datum) =>
//   //             datum.judulBerita!.toLowerCase().contains(query.toLowerCase()))
//   //         .toList();
//   //     setState(() {
//   //       _searchResult = result;
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Berita Budaya',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue[900],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             // TextField(
//             //   controller: _searchController,
//             //   decoration: InputDecoration(
//             //     hintText: 'Cari berita...',
//             //     suffixIcon: _searchController.text.isNotEmpty
//             //         ? IconButton(
//             //             icon: Icon(Icons.clear),
//             //             onPressed: () {
//             //               _searchController.clear();
//             //               searchBerita('');
//             //             },
//             //           )
//             //         : null,
//             //   ),
//             // ),
//             Expanded(
//               child: FutureBuilder(
//                 future: _futureBerita,
//                 builder: (BuildContext context,
//                     AsyncSnapshot<List<Datum>?> snapshot) {
//                   logger.d("hash data :: ${snapshot.hasData}");
//                   if (snapshot.hasData) {
//                     final data = snapshot.data;
//                     return ListView.builder(
//                       itemCount: data?.length,
//                       itemBuilder: (context, index) {
//                         Datum? dataItem = data?[index];
//                         return Padding(
//                           padding: EdgeInsets.all(8),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => DetailBerita(dataItem),
//                                 ),
//                               );
//                             },
//                             child: Row(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(15)),
//                                   child: Image.network(
//                                     '${ApiUrl().baseUrl}gambar/berita${dataItem?.gambarBerita}',
//                                     fit: BoxFit.cover,
//                                     height: 100,
//                                     width: 100,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "${dataItem?.judulBerita}",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       Text(
//                                         "${dataItem?.kontenBerita}",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       SizedBox(height: 30),
//                                     ],
//                                   ),
//                                 ),
//                                 Positioned(
//                                   right: 20,
//                                   bottom: 10,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => DetailBerita(
//                                               dataItem), // Kirim data berita ke halaman DetailBerita
//                                         ),
//                                       );
//                                     },
//                                     child: Text(
//                                       "Lihat Berita",
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                         color:
//                                             Color.fromARGB(255, 17, 166, 192),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(
//                       child: Text(snapshot.error.toString()),
//                     );
//                   } else {
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.orange,
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // @override
//   // void dispose() {
//   //   _searchController.dispose();
//   //   super.dispose();
//   // }
// }
