import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;
  final String token;

  const ProductDetailPage({super.key, required this.productId, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk'), centerTitle: true),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context, listen: false).getProductById(token, productId),
        builder: (context, snapshot) {
          return Consumer<ProductProvider> (
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final product = provider.productDetail;

              if (product == null) {
                return const Center(child: Text('Produk tidak ditemukan'));
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        product['image_url'] ?? 'https://fakeimg.pl/150',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product['name'] ?? '-',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Stok: ${product['stock'] ?? 'Tidak tersedia'}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showDeleteDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Hapus Produk', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      )
    );
  }
}

void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Hapus Produk'),
      content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
              Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Produk telah dihapus'),
              ),
            );
          },
          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
        )
      ],
    )
  );
}
