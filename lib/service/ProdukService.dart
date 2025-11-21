import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ProductService {
  final String _baseUrl = 'https://learncode.biz.id/api';

  // Ambil daftar kategori
  Future<List<dynamic>> getCategories(String token) async {
    final url = Uri.parse('$_baseUrl/categories');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<dynamic>.from(data['data']);
    } else {
      throw Exception(
        'Gagal mengambil daftar kategori, status code: ${response.statusCode}',
      );
    }
  }

  // Tambah / Edit produk + upload gambar
  Future<Map<String, dynamic>> saveProduct({
    String? id,
    required String namaProduk,
    required String deskripsi,
    required String harga,
    required String stok,
    required String idKategori,
    File? image,
    required String token,
  }) async {
    Uri uri = Uri.parse("$_baseUrl/products/save");

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = "Bearer $token"
      ..fields['nama_produk'] = namaProduk
      ..fields['deskripsi'] = deskripsi
      ..fields['harga'] = harga
      ..fields['stok'] = stok
      ..fields['id_kategori'] = idKategori;

    if (id != null) request.fields['id_produk'] = id;

    if (image != null && await image.exists()) {
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      final mimeSplit = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print("Response saveProduct: $respStr"); // debug response
    return jsonDecode(respStr);
  }
}
