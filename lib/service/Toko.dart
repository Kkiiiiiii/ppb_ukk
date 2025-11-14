import 'package:flutter/material.dart';
class Toko extends StatefulWidget {
  
  const Toko({super.key});

  @override
  
  State<Toko> createState() => _TokoState();
}


class _TokoState extends State<Toko> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Saya', textAlign: TextAlign.center),
      ),
      body: Center(
        child: Text('Toko Page'),
      ),
    );
  }
}