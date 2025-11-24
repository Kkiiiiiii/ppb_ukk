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

  int? selectedCategory; 
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
          ); 
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
          ); 
          categoryLoading = false;

          if (categories.isNotEmpty) {
            selectedCategory = categories[0]['id_kategori'];
          } else {
            selectedCategory = null;
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
      _loadProduk(); // jika kosong → menampilkan semua produk
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
        backgroundColor: Colors.teal,
        elevation: 2,
      ),

      body: Column(
  children: [
    // ===================== FILTER KATEGORI =====================
    Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: categoryLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : categories.isEmpty
              ? const Text("Tidak ada kategori tersedia")
              : DropdownButtonFormField<int>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Pilih Kategori",
                    labelStyle: const TextStyle(color: Colors.teal),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem<int>(
                      value: cat['id_kategori'],
                      child: Text(cat['nama_kategori'] ?? 'Tidak ada nama'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                    _loadProduk(categoryId: value);
                  },
                ),
    ),

    // ===================== SEARCH BOX =====================
    Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: searchC,
        decoration: InputDecoration(
          hintText: "Cari produk...",
          prefixIcon: const Icon(Icons.search, color: Colors.teal),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.teal),
            onPressed: () {
              searchC.clear();
              _loadProduk();
            },
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade200),
          ),
        ),
        onChanged: (value) => _searchProduk(),
      ),
    ),

    // ===================== LIST PRODUK =====================
    Expanded(
      child: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : produkList.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada produk",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: produkList.length,
                  itemBuilder: (context, index) {
                    final p = produkList[index];
                    return Card(
                      elevation: 2,
                      shadowColor: Colors.teal.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 14),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: p['gambar'] != null
                              ? Image.network(
                                  p['gambar'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                )
                              : const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                        ),

                        // NAMA PRODUK
                        title: Text(
                          p['nama_produk'] ?? "Tanpa Nama",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.teal,
                          ),
                        ),

                        // HARGA + STOK
                        subtitle: Text(
                          "Harga: Rp ${p['harga']}\nStok: ${p['stok']}",
                          style: TextStyle(
                            height: 1.4,
                            color: Colors.grey.shade700,
                          ),
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
