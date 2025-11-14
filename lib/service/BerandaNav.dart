import 'package:flutter/material.dart';

class Berandanav extends StatefulWidget {
  const Berandanav({super.key});

  @override
  State<Berandanav> createState() => _BerandanavState();
}

class _BerandanavState extends State<Berandanav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(
      child: Text('Ini halaman Beranda'),
    ),
    Center(
      child: Text('Ini halaman Toko'),
    ),
    Center(
      child: Text('Ini halaman Produk'),
    ),
    Center(
      child: Text('Ini halaman Kategori'),
    ),
    Center(
      child: Text('Ini halaman Profile'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace SMK'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(
          milliseconds: 300,
        ),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), label: 'Beranda'),
          NavigationDestination(
              icon: Icon(Icons.store_outlined), label: 'Toko'),
          NavigationDestination(
              icon: Icon(Icons.shopify_outlined), label: 'Produk'),
          NavigationDestination(
              icon: Icon(Icons.tag_outlined), label: 'Kategori'),
          NavigationDestination(
              icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}
