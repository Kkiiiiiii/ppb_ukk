import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/Loginpage.dart';
// import 'package:ppb_marketplace/service/Beranda.dart';
// import 'package:ppb_marketplace/service/Loginpage.dart';
// import 'package:ppb_marketplace/service/Produk.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  } 
  }