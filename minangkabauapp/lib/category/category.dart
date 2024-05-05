import 'package:flutter/material.dart';
import 'package:minangkabauapp/category/alatmusik.dart';
import 'package:minangkabauapp/category/culture.dart';
import 'package:minangkabauapp/home/homePage.dart';
import 'package:minangkabauapp/bottomNavBar.dart';
import 'package:minangkabauapp/category/makanan.dart';
import 'package:minangkabauapp/category/pakaian.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F9FF),
        title: Text(
          'Category',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F9FF),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)), // Ubah radius menjadi 10
                    color: Colors.green[700],
                  ),
                  dividerColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/categories/makanan.png', // Ubah path gambar sesuai dengan asset makanan
                            width:
                                24, // Sesuaikan ukuran gambar sesuai kebutuhan
                            height: 24,
                          ),
                          SizedBox(
                              width: 8), // Berikan jarak antara gambar dan teks
                          Text('Makanan'), // Ganti teks menjadi 'Makanan'
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/categories/pakaian.png', // Ubah path gambar sesuai dengan asset pakaian
                            width:
                                24, // Sesuaikan ukuran gambar sesuai kebutuhan
                            height: 24,
                          ),
                          SizedBox(
                              width: 8), // Berikan jarak antara gambar dan teks
                          Text('Pakaian'), // Ganti teks menjadi 'Pakaian'
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/categories/alat musik.png', // Ubah path gambar sesuai dengan asset alat musik
                            width:
                                24, // Sesuaikan ukuran gambar sesuai kebutuhan
                            height: 24,
                          ),
                          SizedBox(
                              width: 8), // Berikan jarak antara gambar dan teks
                          Text('Alat Musik'), // Ganti teks menjadi 'Alat Musik'
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/categories/culture.png', // Ubah path gambar sesuai dengan asset culture
                            width:
                                24, // Sesuaikan ukuran gambar sesuai kebutuhan
                            height: 24,
                          ),
                          SizedBox(
                              width: 8), // Berikan jarak antara gambar dan teks
                          Text('Culture'), // Ganti teks menjadi 'Culture'
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                MakananPage(),
                PakaianPage(),
                AlatmusikPage(),
                CulturePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






// class CategoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CategoryList();
//   }
// }

// class CategoryList extends StatefulWidget {
//   @override
//   _CategoryListState createState() => _CategoryListState();
// }

// class _CategoryListState extends State<CategoryList> {
//   Widget? _selectedCategoryContent;

//   @override
//   void initState() {
//     super.initState();
//     _selectedCategoryContent = MakananPage(); // Menampilkan kategori makanan pertama kali
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: <Widget>[
//               CategoryCard(
//                 title: 'Makanan',
//                 imagePath: 'assets/images/categories/makanan.png',
//                 onTap: () {
//                   setState(() {
//                     _selectedCategoryContent = MakananPage();
//                   });
//                 },
//               ),
//               SizedBox(width: 20),
//               CategoryCard(
//                 title: 'Pakaian Adat',
//                 imagePath: 'assets/images/categories/pakaian.png',
//                 onTap: () {
//                   setState(() {
//                     _selectedCategoryContent = PakaianPage();
//                   });
//                 },
//               ),
//               SizedBox(width: 20),
//               CategoryCard(
//                 title: 'Alat Musik',
//                 imagePath: 'assets/images/categories/alat musik.png',
//                 onTap: () {
//                   setState(() {
//                     _selectedCategoryContent = AlatmusikPage();
//                   });
//                 },
//               ),
//               SizedBox(width: 20),
//               CategoryCard(
//                 title: 'Culture',
//                 imagePath: 'assets/images/categories/culture.png',
//                 onTap: () {
//                   setState(() {
//                     _selectedCategoryContent = CulturePage();
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 20),
//         _selectedCategoryContent ?? Container(), // Menampilkan konten kategori yang dipilih
//       ],
//     );
//   }
// }

// class CategoryCard extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final Function onTap;

//   const CategoryCard({
//     Key? key,
//     required this.title,
//     required this.imagePath,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onTap(),
//       child: Container(
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.grey[200],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               imagePath,
//               width: 80,
//               height: 80,
//             ),
//             SizedBox(height: 5),
//             Text(
//               title,
//               style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
