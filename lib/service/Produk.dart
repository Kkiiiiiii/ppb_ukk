import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/EditProduk.dart';
import 'LoginService.dart';
import 'Detail.dart';

class ProdukTokoPage extends StatefulWidget {
  final String token;

  const ProdukTokoPage({super.key, required this.token});

  @override
  State<ProdukTokoPage> createState() => _ProdukTokoPageState();
}

class _ProdukTokoPageState extends State<ProdukTokoPage> {
  final LoginService loginService = LoginService();
  List<dynamic> produkToko = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProdukToko();
  }

  Future<void> _loadProdukToko() async {
    setState(() => loading = true);
    try {
      final response = await loginService.getProdukToko(widget.token);

      // pastikan response['data']['produk'] ada
      if (response != null &&
          response['data'] != null &&
          response['data']['produk'] != null) {
        setState(() {
          produkToko = List<dynamic>.from(response['data']['produk']);
          loading = false;
        });
        print("DEBUG PRODUK TOKO: $produkToko");
      } else {
        setState(() {
          produkToko = [];
          loading = false;
        });
        print("DEBUG PRODUK TOKO KOSONG");
      }
    } catch (e) {
      print("Error load produk toko: $e");
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal load produk toko: $e")));
    }
  }

  Future<void> _deleteProduk(int id) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: const Text("Apakah Anda yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed) {
      try {
        await loginService.deleteProdukToko(widget.token, id);
        setState(() {
          produkToko.removeWhere((prod) => prod['id_produk'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil dihapus")),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal menghapus produk")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produk Toko"), centerTitle: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : produkToko.isEmpty
          ? const Center(child: Text("Tidak ada produk toko"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: produkToko.length,
              itemBuilder: (context, index) {
                final p = produkToko[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading:
                              (p['images'] != null && p['images'].isNotEmpty)
                              ? Image.network(
                                  p['images'][0]['url'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(
                            p['nama_produk'] ?? "Tanpa Nama",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          subtitle: Text(
                            "Harga: Rp ${p['harga']}\nStok: ${p['stok']}\nDeskripsi: ${p['deskripsi']}",
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(
                                  token: widget.token,
                                  productId: p['id_produk'],
                                ),
                              ),
                            );
                          },
                        ),

                        const Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Editproduk(
                                      token: widget.token,
                                      produk: p,
                                    ),
                                  ),
                                ).then((updated) {
                                  if (updated == true) {
                                    _loadProdukToko(); // reload setelah edit
                                  }
                                });
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              label: const Text(
                                "Edit",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),

                            const SizedBox(width: 8),

                            TextButton.icon(
                              onPressed: () => _deleteProduk(p['id_produk']),
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text(
                                "Hapus",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
