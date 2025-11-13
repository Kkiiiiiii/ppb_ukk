import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/Beranda.dart';
// import 'Profile.dart';
import 'Detail.dart';
import 'Produk.dart';
import 'Toko.dart';

class Beranda extends StatefulWidget {
  final int userId;
  const Beranda({super.key, required this.userId});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BerandaPage(),
      Detail(),
      Toko(),
      Produk(),
      // Profile(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplikasi MarketPlace')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.tag_rounded), selectedIcon: Icon(Icons.history), label: 'Detail Product'),
          NavigationDestination(icon: Icon(Icons.store), selectedIcon: Icon(Icons.shopping_bag), label: 'Toko Saya'),
          NavigationDestination(icon: Icon(Icons.person_outlined), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.payment_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Produk'),
        ],
      ),
    );
  }
}
