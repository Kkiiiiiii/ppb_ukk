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
          product = data['data'];
          loading = false;
        });
      } else {
        throw Exception('Gagal mengambil detail produk, status code: ${response.statusCode}');
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
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Produk di tengah
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Container(
                            color: Colors.grey.shade200,
                            width: double.infinity,
                            height: 200,
                            child: product!['gambar'] != null
                                ? Center(
                                    child: Image.network(
                                      product!['gambar'],
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.broken_image,
                                        size: 80,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 80,
                                    ),
                                  ),
                          ),
                        ),
                        // Konten Teks
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product!['nama_produk'] ?? "Tanpa Nama",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Harga: Rp ${product!['harga'] ?? '-'}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Stok: ${product!['stok'] ?? '-'}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Deskripsi:",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product!['deskripsi'] ?? "-",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Tanggal Upload: ${product!['tanggal_upload'] ?? '-'}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
