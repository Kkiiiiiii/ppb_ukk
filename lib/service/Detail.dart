import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  final String token;
  final int productId;

  const Detail({super.key, required this.token, required this.productId});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Map<String, dynamic>? produk;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProdukDetail();
  }

  Future<void> loadProdukDetail() async {
    final url = Uri.parse('https://learncode.biz.id/api/products/${widget.productId}');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          produk = data['data']; // asumsi API return { "data": {...} }
          loading = false;
        });
      } else {
        throw Exception('Gagal memuat produk, status: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (produk == null) return const Scaffold(body: Center(child: Text("Produk tidak ditemukan")));

    return Scaffold(
      appBar: AppBar(title: Text(produk!['nama'] ?? 'Detail Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            produk!['gambar'] != null
                ? Image.network(
                    produk!['gambar'],
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Text("Gagal memuat gambar", style: TextStyle(color: Colors.red)),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 16),
            Text(
              produk!['nama'] ?? '-',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Harga: Rp ${produk!['harga'] ?? '-'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Stok: ${produk!['stok'] ?? '-'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              produk!['deskripsi'] ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
