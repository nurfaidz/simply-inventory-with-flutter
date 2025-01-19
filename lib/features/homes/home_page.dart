import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Inventory')),
      body:  Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/product'),
              child: const Text('Produk'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/incoming'),
              child: const Text('Barang Masuk')
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/outgoing'),
              child: const Text('Barang Keluar')
            ),
          ]
        ),
      ),
    );
  }
}