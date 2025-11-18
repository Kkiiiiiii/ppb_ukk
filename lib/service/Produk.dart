import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/Detail.dart';
import 'package:ppb_marketplace/service/LoginService.dart';
class Produk extends StatefulWidget {
  final String token;

  const Produk({super.key, required this.token});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final LoginService loginService = LoginService();
  List<dynamic>? produkList;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProduk();
  }

  Future<void> loadProduk() async {
    try {
      final data = await loginService.getProduk(widget.token);
      setState(() {
        produkList = data;
        loading = false;
      });
    } catch (e) {
      print("Error: $e");
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

    if (produkList == null || produkList!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Tidak ada produk")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Produk")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: produkList!.length,
        itemBuilder: (context, index) {
          final p = produkList![index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: p['gambar'] != null
                  ? Image.network(
                      p['gambar'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    )
                  : const Icon(Icons.image_not_supported),

              title: Text(p['nama_produk'] ?? "Tanpa Nama"),
              subtitle: Text(
                "Harga: Rp ${p['harga']}\nStok: ${p['stok']}",
              ),

              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Detail(
                    token: widget.token,
                    productId: p['id_produk'], // id produk yang diklik
                  ),
                ),
              );
            },
            ),
          );
        },
      ),
    );
  }
}
