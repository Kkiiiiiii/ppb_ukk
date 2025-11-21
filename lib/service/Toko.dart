import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/LoginService.dart';
import 'TambahProduk.dart'; // ⬅️ pastikan import halaman tambah produk

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
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (toko == null) {
      return const Scaffold(
        body: Center(child: Text("Gagal memuat toko")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Toko Saya"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 2,
      ),

      // 🔥 FLOATING BUTTON TAMBAH PRODUK
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Produk"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TambahProdukPage(token: widget.token,), 
            ),
          );
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                toko!['nama_toko'],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                toko!['deskripsi'],
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Text("Kontak: ${toko!['kontak_toko']}"),
              Text("Alamat: ${toko!['alamat']}"),
              const SizedBox(height: 20),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: toko!['gambar'] != null
                    ? Image.network(
                        toko!['gambar'],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Text(
                          "Gagal memuat gambar",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : const Text("Tidak ada gambar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
