import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  final List<Map<String, String>> products = const [
    {
      'name': 'Produk 1',
      'price': 'Rp 100.000',
      'image': 'https://fakeimg.pl/150'
    },
    {
      'name': 'Produk 2',
      'price': 'Rp 200.000',
      'image': 'https://fakeimg.pl/150'
    },
    {
      'name': 'Produk 3',
      'price': 'Rp 300.000',
      'image': 'https://fakeimg.pl/150'
    },
    {
      'name': 'Produk 4',
      'price': 'Rp 400.000',
      'image': 'https://fakeimg.pl/150'
    },
    {
      'name': 'Produk 5',
      'price': 'Rp 500.000',
      'image': 'https://fakeimg.pl/150'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Daftar Produk'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(
                name: product['name']!,
                price: product['price']!,
                imageUrl: product['image']!,
              );
            },
          ),
        ));
  }

  Widget _buildProductCard(
      {required String name, required String price, required String imageUrl}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(price, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          print('Tapped $name');
        },
      ),
    );
  }
}
