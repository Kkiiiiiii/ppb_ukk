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
