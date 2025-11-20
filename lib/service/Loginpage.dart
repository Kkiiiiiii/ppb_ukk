import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/BerandaNav.dart';
import 'package:ppb_marketplace/service/LoginService.dart';
import 'package:ppb_marketplace/service/Register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginService _loginService = LoginService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Card(
          elevation: 8,
          child: Container(
            padding:  EdgeInsets.all(32.0),
            constraints:  BoxConstraints(maxWidth: 350),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   FlutterLogo(size: 100),
                   SizedBox(height: 16),
                  Text(
                    "MarketPlace Sekolah",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                 SizedBox(height: 8),
                  Text(
                    "Silakan login untuk melanjutkan",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),

                  // Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
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
                   SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      hintText: 'Masukkan kata sandi',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() => _isLoading = true);

              try {
                // Call API login
                final result = await _loginService.login(
                  _usernameController.text.trim(),
                  _passwordController.text.trim(),
                );

                if (!mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Berandanav(
                      token: result['token'],
                      userId: result['userId'],
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Terjadi kesalahan: $e'),
                  ),
                );
              } finally {
                setState(() => _isLoading = false);
              }
            }
          },
    child: _isLoading
        ? CircularProgressIndicator(
            color: Colors.white,
          )
        : Text(
            'Masuk',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
  ),
),

  const SizedBox(height: 16),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Belum punya akun? "),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Register()),
          );
        },
      child: const Text(
        "Daftar",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
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
