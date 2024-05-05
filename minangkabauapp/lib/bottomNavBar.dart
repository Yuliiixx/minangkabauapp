import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:minangkabauapp/category/category.dart';
import 'package:minangkabauapp/home/home.dart';
import 'package:minangkabauapp/pahlawan/pahlawan.dart';
import 'package:minangkabauapp/profile/profile.dart';

class BottomNavigation extends StatefulWidget {
  final String initialRoute;

  BottomNavigation(this.initialRoute);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  String initialRoute = "";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    var logger = Logger();
    initialRoute = widget.initialRoute;
    logger.d("Data dari push :: $initialRoute");

    // Pengecekan nilai initialRoute
    if (initialRoute == "pahlawan") {
      setState(() {
        _selectedIndex = 2;
      });
    } else if (initialRoute == "profil") {
      setState(() {
        _selectedIndex = 3;
      });
    } else {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  final List<Widget> _pages = [
    HomePage(),
    PahlawanPage(),
    CategoryPage(),
    Profil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _selectedIndex == 0 ? Colors.green[900] : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library,
                color: _selectedIndex == 1 ? Colors.green[900] : Colors.grey),
            label: 'Pahlawan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people,
                color: _selectedIndex == 2 ? Colors.green[900]: Colors.grey),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _selectedIndex == 3 ? Colors.green[900] : Colors.grey),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
