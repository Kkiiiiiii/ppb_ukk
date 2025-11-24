import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/LoginService.dart';

class Editproduk extends StatefulWidget {
  final String token;
  final Map<String, dynamic> produk;

  const Editproduk({super.key, required this.token, required this.produk});

  @override
  State<Editproduk> createState() => _EditprodukState();
}

class _EditprodukState extends State<Editproduk> {
  final LoginService loginService = LoginService();

  final TextEditingController namaC = TextEditingController();
  final TextEditingController hargaC = TextEditingController();
  final TextEditingController stokC = TextEditingController();
  final TextEditingController deskripsiC = TextEditingController();

  String? selectedKategori;
  String? selectedImagePath;

  final List<Map<String, dynamic>> kategoriList = [
    {"id": 1, "nama": "Elektronik"},
    {"id": 2, "nama": "Buku"},
    {"id": 3, "nama": "Seragam"},
    {"id": 4, "nama": "ATK"},
    {"id": 5, "nama": "Aksesoris"},
    {"id": 6, "nama": "Software"},
    {"id": 8, "nama": "Alat Musik"},
    {"id": 9, "nama": "Kamera"},
    {"id": 10, "nama": "Perabot Sekolah"},
  ];

  @override
  void initState() {
    super.initState();

    // Isi data awal ke form
    namaC.text = widget.produk['nama_produk'] ?? "";
    hargaC.text = widget.produk['harga'].toString();
    stokC.text = widget.produk['stok'].toString();
    deskripsiC.text = widget.produk['deskripsi'] ?? "";

    selectedKategori = widget.produk['id_kategori']?.toString();

    // Kalau null atau tidak cocok dengan list dropdown → set null biar dropdown aman
    if (selectedKategori == null ||
        !kategoriList.any((e) => e["id"].toString() == selectedKategori)) {
      selectedKategori = null;
    }
  }

  Future<void> _simpanEdit() async {
    try {
      await loginService.editProduct(
        widget.token,
        widget.produk['id_produk'],
        namaProduk: namaC.text,
        idKategori: selectedKategori!,
        harga: hargaC.text,
        stok: stokC.text,
        deskripsi: deskripsiC.text,
        images: selectedImagePath != null ? [selectedImagePath!] : [],
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Produk berhasil diedit")));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal edit produk: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Produk"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE PICKER
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: picker gambar
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
                      ? (widget.produk['images'] != null &&
                                widget.produk['images'].isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  widget.produk['images'][0]['url'],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.add_a_photo, size: 40))
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

            // NAMA PRODUK
            const Text(
              "Nama Produk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: namaC,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // KATEGORI
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
                value:
                    kategoriList.any(
                      (e) => e["id"].toString() == selectedKategori,
                    )
                    ? selectedKategori
                    : null,
                isExpanded: true,
                underline: const SizedBox(),
                hint: const Text("Pilih kategori"),
                items: kategoriList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item["id"].toString(),
                    child: Text(item["nama"]),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  selectedKategori = value;
                }),
              ),
            ),

            const SizedBox(height: 16),

            // HARGA
            const Text("Harga", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: hargaC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // STOK
            const Text("Stok", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: stokC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // DESKRIPSI
            const Text(
              "Deskripsi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: deskripsiC,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedKategori == null ? null : _simpanEdit,
                child: const Text(
                  "Simpan Perubahan",
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
