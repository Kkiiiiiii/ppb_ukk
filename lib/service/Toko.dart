import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/LoginService.dart';

class Toko extends StatefulWidget {
  final String token;

  const Toko({super.key, required this.token});

  @override
  State<Toko> createState() => _TokoState();
}

class _TokoState extends State<Toko> {
  final LoginService _loginService = LoginService();
  late Future<List<Map<String, dynamic>>> _tokoFuture;

  @override
  void initState() {
    super.initState();
    _tokoFuture = _loginService.getToko(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tokoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat toko: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada toko tersedia'));
          }

          final tokoList = snapshot.data!;
          return ListView.builder(
            itemCount: tokoList.length,
            itemBuilder: (context, index) {
              final toko = tokoList[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: toko['gambar'] != null
                      ? Image.network(
                          toko['gambar'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.store),
                  title: Text(toko['nama_toko'] ?? '-'),
                  subtitle: Text(toko['alamat'] ?? '-'),
                  onTap: () {
                    // Bisa ditambahkan detail toko atau produk
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
