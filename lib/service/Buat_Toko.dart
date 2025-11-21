import 'package:flutter/material.dart';
class BuatToko extends StatefulWidget {
  const BuatToko({super.key});

  @override
  State<BuatToko> createState() => _BuatTokoState();
}

class _BuatTokoState extends State<BuatToko> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Toko"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: [],
        ),
      ),
    );
  }
}