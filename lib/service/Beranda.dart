import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/LoginService.dart';
import 'Detail.dart';

class BerandaPage extends StatefulWidget {
  final String token;

  const BerandaPage({super.key, required this.token});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final LoginService loginService = LoginService();
  List<dynamic> produkList = [];
  bool loading = true;

  final TextEditingController searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProduk();
  }

  // ===== LOAD ALL PRODUK =====
  Future<void> _loadProduk() async {
    try {
      final data = await loginService.getProduk(widget.token);
      setState(() {
        produkList = data;
        loading = false;
      });
    } catch (e) {
      print("Error load produk: $e");
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal load daftar produk")));
    }
  }

  // ============ SEARCH PRODUK ============
  Future<void> _searchProduk() async {
    if (searchC.text.isEmpty) {
      _loadProduk(); // jika kosong → tampilkan semua produk
      return;
    }

    setState(() => loading = true);

    try {
      final results = await loginService.searchProduk(
        widget.token,
        searchC.text,
      );

      setState(() {
        produkList = results;
        loading = false;
      });
    } catch (e) {
      print("Error search: $e");
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mencari produk")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Beranda"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 2,
      ),

      body: Column(
        children: [
          // ================= SEARCH BOX ==================
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchC,
              decoration: InputDecoration(
                hintText: "Cari produk...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchC.clear();
                    _loadProduk();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _searchProduk(); // realtime search
              },
            ),
          ),

          // ===== LIST PRODUK ======
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : produkList.isEmpty
                ? const Center(child: Text("Tidak ada produk"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: produkList.length,
                    itemBuilder: (context, index) {
                      final p = produkList[index];
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
