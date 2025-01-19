import 'package:flutter/material.dart';

class OutgoingItemPage extends StatelessWidget {
  const OutgoingItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barang Keluar')),
      body: const Center(
        child: Text('Daftar Barang Keluar'),
      ),
    );
  }
}