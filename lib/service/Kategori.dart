import 'package:flutter/material.dart';
import 'LoginService.dart'; // import LoginService kamu

class Kategori extends StatefulWidget {
  final String token; // token user untuk auth
  const Kategori({super.key, required this.token});

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  final LoginService loginService = LoginService();
  List<dynamic> categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await loginService.getCategories(widget.token);
      setState(() {
        categories = data;
        loading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal load kategori")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Kategori"), centerTitle: true, backgroundColor: Colors.teal,),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
          ? const Center(child: Text("Tidak ada kategori"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      "Kategori:\t${cat['nama_kategori'] ?? "Tanpa Nama"}",
                    ),
                    subtitle: Text("ID: ${cat['id_kategori']}"),
                    leading: const Icon(Icons.category),
                    onTap: () {
                      // Bisa tambahkan aksi ketika kategori dipilih
                    },
                  ),
                );
              },
            ),
    );
  }
}
