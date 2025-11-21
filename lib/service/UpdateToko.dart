import 'package:flutter/material.dart';

class Updatetoko extends StatefulWidget {
  const Updatetoko({super.key});

  @override
  State<Updatetoko> createState() => _UpdatetokoState();
}

class _UpdatetokoState extends State<Updatetoko> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Toko'),
        titleTextStyle: TextStyle(color: Colors.amber),
      ),
    );
  }
}
