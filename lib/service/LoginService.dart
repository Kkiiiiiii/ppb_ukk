import 'dart:convert';
import 'package:http/http.dart' as http;

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
        return {
          'token': token,
          'userId': userId,
          'username': username,
        };
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
      throw Exception('Gagal mengambil data user, status code: ${response.statusCode}');
    }
  }
  //register
 Future<Map<String, dynamic>> register(String nama, String username, int kontak, String password) async {
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
    final url = Uri.parse('$_baseUrl/products'); // sesuaikan endpoint API produk

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
    body: jsonEncode({
      'nama': nama,
      'username': username,
      'kontak': kontak,
    }),
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
      'Gagal update profile, status code: ${response.statusCode}');
}

}
