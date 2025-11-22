import 'package:flutter/material.dart';
import 'LoginService.dart';

class ProfileUpdatePage extends StatefulWidget {
  final String token;
  final Map<String, dynamic> userData;

  const ProfileUpdatePage({
    required this.token,
    required this.userData,
    super.key,
  });

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final LoginService _service = LoginService();

  late TextEditingController namaController;
  late TextEditingController usernameController;
  late TextEditingController kontakController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.userData['nama']);
    usernameController = TextEditingController(
      text: widget.userData['username'],
    );
    kontakController = TextEditingController(
      text: widget.userData['kontak'].toString(),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    usernameController.dispose();
    kontakController.dispose();
    super.dispose();
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final result = await _service.updateProfile(
        widget.token,
        nama: namaController.text,
        username: usernameController.text,
        kontak: kontakController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil berhasil diperbarui"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
      Navigator.pop(context, updateProfile());
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NAMA
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // USERNAME
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Username wajib diisi"
                    : null,
              ),
              const SizedBox(height: 16),

              // KONTAK
              TextFormField(
                controller: kontakController,
                decoration: const InputDecoration(
                  labelText: "Nomor Kontak",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? "Kontak wajib diisi"
                    : null,
              ),
              const SizedBox(height: 24),

              // BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updateProfile,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update Profile"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
