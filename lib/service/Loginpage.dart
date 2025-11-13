import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/Beranda.dart';
import 'package:ppb_marketplace/service/BerandaNav.dart';
import 'package:ppb_marketplace/service/LoginService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Loginservice _loginService = Loginservice();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 350),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo (opsional)
                  FlutterLogo(size: 100),
                  const SizedBox(height: 16),
                  Text(
                    "MarketPlace Sekolah",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Silakan login untuk melanjutkan",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),

                  // Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Masukkan username Anda',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      hintText: 'Masukkan kata sandi',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() => _isLoading = true);

                                try {
                                  // Coba login via API
                                  final success = await _loginService.login(
                                    _usernameController.text.trim(),
                                    _passwordController.text.trim(),
                                  );

                                  if (!mounted) return;

                                  if (success) {
                                    // Jika login berhasil → navigasi ke HomePage
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const  BerandaPage(),
                                      ),
                                    );
                                  } else {
                                    // Jika gagal
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Login gagal, periksa kembali akun Anda')),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Terjadi kesalahan: $e')),
                                  );
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Masuk',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
