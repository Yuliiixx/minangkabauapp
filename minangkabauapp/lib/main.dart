import 'package:flutter/material.dart';
import 'package:minangkabauapp/login.dart';
import 'package:minangkabauapp/splashscreen.dart';
import 'package:minangkabauapp/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false, // Hide debug banner for the root MaterialApp
    );
  }
}