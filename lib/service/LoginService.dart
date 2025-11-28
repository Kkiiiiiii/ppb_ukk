import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class LoginService {
  final String _baseUrl = 'https://learncode.biz.id/api';

  // LOGIN
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final token = data['token'];
        final userId = data['data']['id_user'].toString();
        final username = data['data']['username'];
        return {'token': token, 'userId': userId, 'username': username};
      } else {
        throw Exception(data['message'] ?? 'Login gagal');
      }
    } else {
      throw Exception('Gagal login, status code: ${response.statusCode}');
    }
  }

  // Ambil profile user
  Future<Map<String, dynamic>> getUserProfile(String token) async {
    final url = Uri.parse('$_baseUrl/profile');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception(
        'Gagal mengambil data user, status code: ${response.statusCode}',
      );
    }
  }

  //register
  Future<Map<String, dynamic>> register(
    String nama,
    String username,
    int kontak,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'username': username,
        'kontak': kontak,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)['data'];
    } else if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception(data['errors'] ?? data['message']);
    } else {
      throw Exception('Gagal registrasi, status code: ${response.statusCode}');
    }
  }

  //Toko
  Future<Map<String, dynamic>> getToko(String token) async {
    final url = Uri.parse('$_baseUrl/stores');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data["data"]);
    }

    throw Exception(
      'Gagal mengambil data toko, status code: ${response.statusCode}',
    );
  }

  // Ambil daftar produk
  Future<List<dynamic>> getProduk(String token) async {
    final url = Uri.parse(
      '$_baseUrl/products',
    ); // sesuaikan endpoint API produk

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Status Produk: ${response.statusCode}");
    print("Body Produk: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return List<dynamic>.from(data['data']);
    }

    throw Exception(
      'Gagal mengambil data produk, status code: ${response.statusCode}',
    );
  }

  // UPDATE PROFILE
  Future<Map<String, dynamic>> updateProfile(
    String token, {
    required String nama,
    required String username,
    required String kontak,
  }) async {
    final url = Uri.parse('$_baseUrl/profile/update');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nama': nama, 'username': username, 'kontak': kontak}),
    );

    print("Status Update: ${response.statusCode}");
    print("Body Update: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return Map<String, dynamic>.from(data['data']);
    }

    // jika error 422
    if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception(data['errors'] ?? data['message']);
    }

    throw Exception(
      'Gagal update profile, status code: ${response.statusCode}',
    );
  }

  Future<Map<String, dynamic>> addProduct(
    String token, {
    required String namaProduk,
    required String idKategori,
    required String harga,
    required String stok,
    required String deskripsi,
    List<String>? images,
  }) async {
    final url = Uri.parse('$_baseUrl/products');

    final body = {
      'nama_produk': namaProduk,
      'id_kategori': idKategori,
      'harga': harga,
      'stok': stok,
      'deskripsi': deskripsi,
      'images': images ?? [],
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    print("Status Add Product: ${response.statusCode}");
    print("Body Add Product: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data']);
    } else if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception(data['errors'] ?? data['message']);
    } else {
      throw Exception(
        'Gagal tambah produk, status code: ${response.statusCode}',
      );
    }
  }

  //Kategori//
  Future<List<dynamic>> getCategories(String token) async {
    final url = Uri.parse('$_baseUrl/categories');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // jika API membutuhkan auth
      },
    );

    print("Status Kategori: ${response.statusCode}");
    print("Body Kategori: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<dynamic>.from(data['data']);
    }

    throw Exception(
      'Gagal mengambil daftar kategori, status code: ${response.statusCode}',
    );
  }

  Future<Map<String, dynamic>> getProdukToko(String token) async {
    final url = Uri.parse('https://learncode.biz.id/api/stores/products');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // return seluruh JSON agar bisa ambil data['produk']
    } else {
      throw Exception(
        'Gagal mengambil data produk toko, status code: ${response.statusCode}',
      );
    }
  }
  // Hapus produk toko
  Future<void> deleteProdukToko(String token, int idProduk) async {
    final url = Uri.parse(
      'https://learncode.biz.id/api/products/$idProduk/delete',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Status Delete: ${response.statusCode}");
    print("Body Delete: ${response.body}");

    if (response.statusCode == 200) {
      // Berhasil dihapus
      return;
    } else {
      throw Exception(
        'Gagal menghapus produk, status code: ${response.statusCode}',
      );
    }
  }
  // Edit Produk //
  Future<void> editProduct(
    String token,
    int idProduk, {
    required String namaProduk,
    required String idKategori,
    required String harga,
    required String stok,
    required String deskripsi,
    List<String>? images, // array URL/file path
  }) async {
    final url = Uri.parse("$_baseUrl/products/save");

    final Map<String, dynamic> body = {
      "id_produk": idProduk,
      "nama_produk": namaProduk,
      "id_kategori": idKategori,
      "harga": harga,
      "stok": stok,
      "deskripsi": deskripsi,
      "images": images ?? [],
    };

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      if (res['success'] != true) {
        throw Exception(res['message'] ?? "Gagal edit produk");
      }
    } else {
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  }
  //Search//
  Future<List<dynamic>> searchProduk(String token, String keyword) async {
    final url = Uri.parse(
      "https://learncode.biz.id/api/products/search?keyword=$keyword",
    );

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      if (res["success"] == true && res["data"] != null) {
        return List<dynamic>.from(res["data"]);
      } else {
        return [];
      }
    } else {
      throw Exception("Gagal mencari produk (${response.statusCode})");
    }
  }

  //Buat Toko
  Future<Map<String, dynamic>> createStore({
    required String token,
    required String namaToko,
    required String deskripsi,
    required String kontak,
    required String alamat,
    File? image,
  }) async {
    final uri = Uri.parse("$_baseUrl/stores/save");
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['nama_toko'] = namaToko
      ..fields['deskripsi'] = deskripsi
      ..fields['kontak'] = kontak
      ..fields['alamat'] = alamat;

    if (image != null) {
      final mimeType =
          lookupMimeType(image.path) ?? 'image/jpeg'; 
      final mimeSplit = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'gambar',
          image.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(respStr);
      return Map<String, dynamic>.from(data);
    } else {
      final data = jsonDecode(respStr);
      throw Exception(data['message'] ?? 'Gagal membuat toko');
    }
  }

  Future<Map<String, dynamic>> saveStore(
    String token,
    Map<String, dynamic> storeData,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/stores/save'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(storeData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to save store');
    }
  }

  //filter kat
  Future<List<dynamic>> byCategory  (String token, int idUser) async {
    final url = Uri.parse(
      "https://learncode.biz.id/api/products/category/$idUser",
    );

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      if (res["success"] == true && res["data"] != null) {
        return List<dynamic>.from(res["data"]);
      } else {
        return [];
      }
    } else {
      throw Exception("Gagal mencari data berdasarkan kategori(${response.statusCode})");
    }
  }

  Future<bool> deleteToko(String token, int storeId) async {
  final url = Uri.parse("https://learncode.biz.id/api/stores/$storeId/delete");

  try {
    final response = await http
        .post(
          url,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          body: {}, // Laravel kadang butuh body untuk POST delete
        )
        .timeout(const Duration(seconds: 8));

    print("Delete Status: ${response.statusCode}");
    print("Delete Body: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return true;
    }
    return false;
  } catch (e) {
    print("Delete Error: $e");
    return false;
  }
}
}
