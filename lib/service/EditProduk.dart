import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/Produk.dart';

class TambahProduk extends StatefulWidget {
  final String token;
  const TambahProduk({super.key, required this.token});

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  final TextEditingController namaC = TextEditingController();
  final TextEditingController hargaC = TextEditingController();
  final TextEditingController stokC = TextEditingController();
  final TextEditingController deskripsiC = TextEditingController();

  String? selectedKategori;

  final List<Map<String, dynamic>> kategoriList = [
    {"id": 1, "nama": "ATK"},
    {"id": 2, "nama": "Elektronik"},
    {"id": 7, "nama": "Hardware"},
  ];

  String? selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: GestureDetector(
                onTap: () {
                  // buka file picker nanti
                },
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: selectedImagePath == null
                      ? const Center(
                          child: Icon(Icons.add_a_photo,
                              size: 40, color: Colors.grey),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            File(selectedImagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Nama Produk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: namaC,
              decoration: InputDecoration(
                hintText: "Masukkan nama produk",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Kategori",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButton<String>(
                value: selectedKategori,
                isExpanded: true,
                underline: const SizedBox(),
                hint: const Text("Pilih kategori"),
                items: kategoriList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item["id"].toString(),
                    child: Text(item["nama"]),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedKategori = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Harga",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: hargaC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Masukkan harga",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Stok",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: stokC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Masukkan stok",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Deskripsi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: deskripsiC,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Masukkan deskripsi produk",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukTokoPage(token: widget.token)),
                );
                },
                child: const Text(
                  "Simpan Produk",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

