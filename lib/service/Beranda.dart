import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/LoginService.dart';
import 'Detail.dart';
import 'package:http/http.dart' as http;

class BerandaPage extends StatefulWidget {
  final String token;

  const BerandaPage({super.key, required this.token});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final LoginService loginService = LoginService();
  List<dynamic> produkList = [];
  List<dynamic> categories = []; // Kategori yang akan ditampilkan di dropdown
  bool loading = true;
  bool categoryLoading = false; // Status loading kategori

  int? selectedCategory; // ID kategori yang dipilih
  final TextEditingController searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProduk();
    _loadCategories();
  }

  // ===== LOAD ALL PRODUK =====
  Future<void> _loadProduk({int? categoryId}) async {
    setState(() => loading = true);

    String url = categoryId != null
        ? "https://learncode.biz.id/api/products/category/$categoryId"
        : "https://learncode.biz.id/api/products"; // Endpoint untuk semua produk

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        setState(() {
          produkList = List<dynamic>.from(
            res['data'] ?? [],
          ); // Pastikan tidak null
          loading = false;
        });
      } else {
        setState(() => loading = false);
        throw Exception("Gagal mengambil produk");
      }
    } catch (e) {
      setState(() => loading = false);
      print("Error load produk: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal load daftar produk")));
    }
  }

  // ===== LOAD CATEGORIES =====
  Future<void> _loadCategories() async {
    setState(() => categoryLoading = true);

    try {
      final response = await http.get(
        Uri.parse("https://learncode.biz.id/api/categories"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          categories = List<dynamic>.from(
            data['data'] ?? [],
          ); // Pastikan kategori tidak null
          categoryLoading = false;

          // Jika kategori tersedia, pilih kategori pertama secara default
          if (categories.isNotEmpty) {
            selectedCategory = categories[0]['id_kategori'];
          } else {
            selectedCategory = null; // Jika tidak ada kategori, set null
          }
        });
      } else {
        setState(() => categoryLoading = false);
        throw Exception("Gagal mengambil kategori");
      }
    } catch (e) {
      setState(() => categoryLoading = false);
      print("Error load kategori: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mengambil kategori")));
    }
  }

  // ===== SEARCH PRODUK =====
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
          // ================= FILTER KATEGORI =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: categoryLoading
                ? const CircularProgressIndicator()
                : categories.isEmpty
                ? const Text("Tidak ada kategori tersedia")
                : DropdownButtonFormField<int>(
                    value: selectedCategory,
                    hint: const Text("Pilih Kategori"),
                    items: categories.map((cat) {
                      return DropdownMenuItem<int>(
                        value: cat['id_kategori'], // Menggunakan id_kategori
                        child: Text(cat['nama_kategori'] ?? 'Tidak ada nama'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedCategory = value);
                      _loadProduk(
                        categoryId: value,
                      ); // Filter produk berdasarkan kategori
                    },
                  ),
          ),

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
                    _loadProduk(); // jika kosong → tampilkan semua produk
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
                            "Harga: Rp ${p['harga']}\nStok: ${p['stok']}",
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
