import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppb_marketplace/service/ProdukService.dart';

class TambahProdukPage extends StatefulWidget {
  final String token;
  const TambahProdukPage({super.key, required this.token});

  @override
  State<TambahProdukPage> createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final _formKey = GlobalKey<FormState>();
  final _productService = ProductService();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();

  File? image;
  bool _isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => image = File(picked.path));
  }

  Future<void> submitProduk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final res = await _productService.saveProduct(
        namaProduk: namaController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        harga: hargaController.text.trim(),
        stok: stokController.text.trim(),
        idKategori: kategoriController.text.trim(), // input manual
        image: image,
        token: widget.token,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? "Produk berhasil ditambahkan"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();
    hargaController.dispose();
    stokController.dispose();
    kategoriController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: image != null
                      ? Image.file(image!, fit: BoxFit.cover)
                      : const Icon(
                          Icons.add_a_photo,
                          size: 60,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Produk"),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: hargaController,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: stokController,
                decoration: const InputDecoration(labelText: "Stok"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: kategoriController,
                decoration: const InputDecoration(labelText: "ID Kategori"),
                validator: (v) =>
                    v == null || v.isEmpty ? "ID Kategori wajib diisi" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : submitProduk,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Tambah Produk"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
