import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  final String productId;

  const EditProductPage({super.key, required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    bool success =
        await productProvider.updateProduct(token!, widget.productId, {
      'name': _nameController.text,
      'stock': int.tryParse(_stockController.text) ?? 0,
    });

    if (success) {
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil mengubah produk')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah produk')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context).token;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color(0xFF2047A9),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ),
      body: FutureBuilder(
          future: Provider.of<ProductProvider>(context, listen: false)
              .getProductById(token!, widget.productId),
          builder: (context, snapshot) {
            return Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final product = provider.productDetail;

                if (product == null) {
                  return const Center(child: Text('Produk tidak ditemukan'));
                }

                _nameController.text = product['name'];
                _stockController.text = product['stock'].toString();

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Nama Barang',
                            labelStyle: TextStyle(color: Color(0xFF2047A9)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            )
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Nama barang tidak boleh kosong'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Color(0xFF2047A9)),
                              labelText: 'Stok Barang',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Stok barang tidak boleh kosong';
                            if (int.tryParse(value) == null)
                              return 'Stok barang harus berupa angka';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _updateProduct,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                                child: const Text('Ubah'),
                              ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
