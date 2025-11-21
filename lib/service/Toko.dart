import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/Buat_Toko.dart';
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
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Toko Saya"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 2,
      ),

      body: toko == null
          ? Center(
              child: ElevatedButton(
                onPressed: () async {
                  final created = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BuatToko(token: widget.token),
                    ),
                  );

                  // reload toko setelah berhasil buat
                  if (created == true) loadToko();
                },
                child: const Text("Buka Toko"),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama toko
                    Text(
                      toko!['nama_toko'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Deskripsi toko
                    Text(
                      toko!['deskripsi'] ?? "-",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kontak dan alamat
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 18, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(
                          toko!['kontak_toko'] ?? "-",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            toko!['alamat'] ?? "-",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Gambar toko
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: toko!['gambar'] != null
                          ? Image.network(
                              toko!['gambar'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  height: 200,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                height: 200,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Text(
                                    "Gagal memuat gambar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 200,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Text("Tidak ada gambar"),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

      floatingActionButton: toko != null
          ? FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Produk"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahProdukPage(token: widget.token),
                  ),
                );
              },
            )
          : null,
    );
  }
}
