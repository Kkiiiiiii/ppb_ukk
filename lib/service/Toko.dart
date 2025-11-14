import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/LoginService.dart';

class Toko extends StatefulWidget {
  final String token;

  const Toko({super.key, required this.token});

  @override
  State<Toko> createState() => _TokoState();
}

class _TokoState extends State<Toko> {
  final LoginService loginService = LoginService();
  Map<String, dynamic>? toko;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadToko();
  }

  Future<void> loadToko() async {
    try {
      final data = await loginService.getToko(widget.token);
      setState(() {
        toko = data;
        loading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());
    if (toko == null) return Center(child: Text("Gagal memuat toko"));

    return Scaffold(
      appBar: AppBar(title: const Text("Toko Saya")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Toko: ${toko!['nama_toko']}"),
            Text("Deskripsi: ${toko!['deskripsi']}"),
            Text("Kontak: ${toko!['kontak_toko']}"),
            Text("Alamat: ${toko!['alamat']}"),
            const SizedBox(height: 10),

            toko!['gambar'] != null
                ? Image.network(
                    toko!['gambar'],
                    height: 150,
                    fit: BoxFit.cover,
                    headers: const {
                      "Access-Control-Allow-Origin": "*",
                    },
                    errorBuilder: (_, __, ___) =>
                        const Text("Gagal memuat gambar", style: TextStyle(color: Colors.red)),
                  )
                : Text("Tidak ada gambar"),
          ],  
        ),
      ),
    );
  }
}
