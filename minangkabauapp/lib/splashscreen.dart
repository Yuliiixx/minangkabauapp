import 'package:flutter/material.dart';
import 'package:minangkabauapp/login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigasi ke halaman login setelah splash screen ditampilkan selama 2 detik
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, // Ganti warna latar belakang sesuai kebutuhan
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                              "assets/images/logo.png", // Ganti dengan path gambar dari asset Anda
              width: 150, // Sesuaikan lebar gambar
              height: 150, // Sesuaikan tinggi gambar
            ),
            SizedBox(height: 15), // Jarak antara gambar dan teks
            Text(
              'Budaya Indonesia',
              style: TextStyle(
                fontSize: 20, // Sesuaikan ukuran teks
                fontWeight: FontWeight.bold,
                color: Colors.black, // Sesuaikan warna teks
              ),
            ),
          ],
        ),
      ),
    );
  }
}


