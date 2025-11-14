import 'package:flutter/material.dart';
class Produk extends StatefulWidget {
  
  const Produk({super.key});

  @override
  
  State<Produk> createState() => _ProdukState();
}


class _ProdukState extends State<Produk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Page', textAlign: TextAlign.center),
      ),
      body: Center(
        child: Text('Produk Page'),
      ),
    );
  }
}