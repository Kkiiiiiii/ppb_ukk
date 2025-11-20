import 'package:flutter/material.dart';
import 'package:ppb_marketplace/service/Beranda.dart';
import 'package:ppb_marketplace/service/Produk.dart';
import 'package:ppb_marketplace/service/Profile.dart';
import 'package:ppb_marketplace/service/Toko.dart';

class Berandanav extends StatefulWidget {
  final String token;
  final String userId;

  Berandanav({super.key, required this.token, required this.userId});

  @override
  State<Berandanav> createState() => _BerandanavState();
}

class _BerandanavState extends State<Berandanav> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BerandaPage(token: widget.token,),
      Toko(token: widget.token),
      Produk(token: widget.token),
      Center(child: Text('Kategori')),
      Profile(token: widget.token),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.store_outlined), label: 'Toko'),
          NavigationDestination(icon: Icon(Icons.shopify_outlined), label: 'Produk'),
          NavigationDestination(icon: Icon(Icons.tag_outlined), label: 'Kategori'),
          NavigationDestination(icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}
