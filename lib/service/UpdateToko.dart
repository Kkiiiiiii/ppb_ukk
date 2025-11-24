import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/LoginService.dart';

class Updatetoko extends StatefulWidget {
  final Map<String, dynamic> toko;
  final String token;
  const Updatetoko({super.key, required this.toko, required this.token});

  @override
  _UpdatetokoState createState() => _UpdatetokoState();
}

class _UpdatetokoState extends State<Updatetoko> {
  final _formKey = GlobalKey<FormState>();

  final LoginService loginService = LoginService();  // ← Tambahkan ini

  TextEditingController _namaTokoController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _kontakController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaTokoController.text = widget.toko['nama_toko'];
    _deskripsiController.text = widget.toko['deskripsi'];
    _kontakController.text = widget.toko['kontak_toko'] ?? '';
    _alamatController.text = widget.toko['alamat'] ?? '';
  }

  Future<void> _updateStore() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedStore = {
        'nama_toko': _namaTokoController.text,
        'deskripsi': _deskripsiController.text,
        'kontak_toko': _kontakController.text,
        'alamat': _alamatController.text,
      };

      // Memanggil dari instance 
      final response = await loginService.saveStore(widget.token, updatedStore);

      if (response != null) {
        Navigator.pop(context, updatedStore);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui toko")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Toko")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaTokoController,
                decoration: InputDecoration(labelText: 'Nama Toko'),
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi Toko'),
              ),
              TextFormField(
                controller: _kontakController,
                decoration: InputDecoration(labelText: 'Kontak Toko'),
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat Toko'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateStore,
                child: const Text("Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
