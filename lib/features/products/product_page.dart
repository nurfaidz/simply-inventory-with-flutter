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
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String token = authProvider.token!;
      productProvider.getProducts(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Produk'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            if (productProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (productProvider.products.isEmpty) {
              return const Center(child: Text('Belum ada produk'));
            }

            return ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return _buildProductCard(context: context, productId:product['id'], name: product['name'] ?? '-', stock: product['stock'], imageUrl: product['image_url'] ?? 'https://fakeimg.pl/150');
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/products/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(
      {required BuildContext context,
      required int productId,
      required String name,
      required int stock,
      required String imageUrl}) {
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
        subtitle: Text('Stock: $stock', style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/products/show',
            arguments: {
              'productId': productId,
              'token': Provider.of<AuthProvider>(context, listen: false).token,
            }
          );
        },
      ),
    );
  }
}
