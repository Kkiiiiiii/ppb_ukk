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
  
  Future<List<Map<String, dynamic>>> getToko(String token) async {
    final url = Uri.parse('$_baseUrl/stores'); // endpoint toko
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Gagal mengambil data toko, status code: ${response.statusCode}');
    }
  }
}
