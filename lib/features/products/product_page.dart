import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String token = authProvider.token!;
      productProvider.getProducts(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF2047A9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            if (productProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (productProvider.products.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada produk',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              itemCount: productProvider.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return _buildProductCard(
                  context: context,
                  productId: product['id'],
                  name: product['name'] ?? '-',
                  stock: product['stock'],
                  imageUrl: product['image_url'] ?? 'https://fakeimg.pl/150',
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/products/create');
        },
        backgroundColor: const Color(0xFF2047A9),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required int productId,
    required String name,
    required int stock,
    required String imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        subtitle: Text(
          'Stock: $stock',
          style: const TextStyle(color: Colors.black87),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Color(0xFF2047A9)),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/products/show',
            arguments: {
              'productId': productId,
              'token': Provider.of<AuthProvider>(context, listen: false).token,
            },
          );
        },
      ),
    );
  }
}
