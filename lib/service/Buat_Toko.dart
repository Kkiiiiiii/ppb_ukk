import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppb_marketplace/service/LoginService.dart';

class BuatToko extends StatefulWidget {
  final String token;
  const BuatToko({super.key, required this.token});

  @override
  State<BuatToko> createState() => _BuatTokoState();
}

class _BuatTokoState extends State<BuatToko> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  File? image;
  bool _isLoading = false;
  final LoginService loginService = LoginService();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => image = File(picked.path));
  }

  Future<void> submitToko() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = await loginService.createStore(
        token: widget.token,
        namaToko: namaController.text,
        deskripsi: deskripsiController.text,
        kontak: kontakController.text,
        alamat: alamatController.text,
        image: image,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? 'Toko berhasil dibuat!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat toko: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Toko")),
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
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(image!, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.add_a_photo, size: 60, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Toko"),
                validator: (v) => v!.isEmpty ? "Nama toko wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: kontakController,
                decoration: const InputDecoration(labelText: "Kontak"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: "Alamat"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : submitToko,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Buat Toko"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
