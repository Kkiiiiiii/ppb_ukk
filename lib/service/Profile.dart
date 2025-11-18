import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/LoginService.dart';
import 'package:ppb_marketplace/service/Loginpage.dart';
import 'package:ppb_marketplace/service/updateProfil.dart';

class Profile extends StatefulWidget {
  final String token;
  Profile({super.key, required this.token});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final LoginService loginService = LoginService();
  Map<String, dynamic>? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final userData = await loginService.getUserProfile(widget.token);
      setState(() {
        user = userData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator());
    if (user == null) return Center(child: Text('Gagal memuat data user'));

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Profile'))),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tampilkan gambar user
            Center(
              child: user!['avatar'] != null
                  ? Image.network(
                      user!['avatar'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, size: 100);
                      },
                    )
                  : const Icon(Icons.person, size: 100),
            ),
            SizedBox(height: 16),
            Text('Nama: ${user!['nama'] ?? '-'}'),
            Text('Username: ${user!['username'] ?? '-'}'),
            Text('Kontak: ${user!['kontak'] ?? '-'}'),
            Text('Role: ${user!['role'] ?? '-'}'),
            SizedBox(height: 20),
             ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman Update Profile dengan data user
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileUpdatePage(
                      token: widget.token,
                      userData: user!, // kirim data user ke halaman update
                    ),
                  ),
                );
              },
              child: Text('Update Profile'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
      
    );
  }
}
