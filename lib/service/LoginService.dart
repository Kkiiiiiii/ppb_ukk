import 'dart:convert';
import 'package:http/http.dart' as http;

class Loginservice {
  final String _baseUrl = 'https://learncode.biz.id/api';

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'];
    } else {
      throw Exception('Failed to login');
    }
  }
}
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class Loginservice {
//   final String _baseUrl = 'https://learncode.biz.id/api';
//   String? token; // token setelah login

//   // Login
//   Future<Map<String, dynamic>> login(String username, String password) async {
//     final url = Uri.parse('$_baseUrl/login');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'username': username, 'password': password}),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       if (data['success'] == true && data['user'] != null) {
//         token = data['token']; // simpan token
//         return {
//           'id': data['user']['id'],
//           'token': data['token'],
//         };
//       } else {
//         throw Exception('Login gagal, periksa username dan password');
//       }
//     } else {
//       throw Exception('Gagal terhubung ke server');
//     }
//   }

//   // Ambil profil user
//   Future<Map<String, dynamic>> getUserProfile(int userId) async {
//     if (token == null) throw Exception('Token belum tersedia');
//     final url = Uri.parse('$_baseUrl/user/$userId');

//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Gagal mengambil profil user');
//     }
//   }
// }
