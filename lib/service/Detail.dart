import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  final String token;
  final int productId; // ID produk yang dipilih

  const Detail({super.key, required this.token, required this.productId});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Map<String, dynamic>? product;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    final url = Uri.parse(
      'https://learncode.biz.id/api/products/${widget.productId}/show',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          product = data['data']; // sesuaikan key dari respons API
          loading = false;
        });
      } else {
        throw Exception(
          'Gagal mengambil detail produk, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : product == null
          ? const Center(child: Text("Produk tidak ditemukan"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  product!['gambar'] != null
                      ? Image.network(
                          product!['gambar'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 100),
                        )
                      : const Icon(Icons.image_not_supported, size: 100),
                  const SizedBox(height: 16),
                  Text(
                    product!['nama_produk'] ?? "Tanpa Nama",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Harga: Rp ${product!['harga']}"),
                  Text("Stok: ${product!['stok']}"),
                  const SizedBox(height: 8),
                  Text("Deskripsi:\n${product!['deskripsi']}"),
                  const SizedBox(height: 8),
                  Text("Tanggal Upload: ${product!['tanggal_upload']}"),
                ],
              ),
            ),
    );
  }
}
