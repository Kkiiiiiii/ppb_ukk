import 'package:flutter/material.dart';
class Tambahproduk extends StatefulWidget {
  const Tambahproduk({super.key});

  @override
  State<Tambahproduk> createState() => _TambahprodukState();
}

class _TambahprodukState extends State<Tambahproduk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Tambah Produk', style: TextStyle(backgroundColor: Colors.teal)),),
    );
  }
}