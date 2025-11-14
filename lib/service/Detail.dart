import 'package:flutter/material.dart';
class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page', textAlign: TextAlign.center),
      ),
      body: Center(
        child: Text('Detail Page'),
      ),
    );
  }
}