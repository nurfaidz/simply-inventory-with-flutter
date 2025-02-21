import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  bool _isLoading = false;

  void _saveForm() async {

    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    bool success = await productProvider.createProduct(token!, {
      'name': _nameController.text,
      'stock': int.tryParse(_stockController.text) ?? 0,
    });

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/products');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data gagal disimpan, coba lagi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk'), centerTitle: true, automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key:  _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Nama barang', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: 'Masukkan nama barang'),
                validator: (value) => (value == null || value.isEmpty) ? 'Nama barang tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              Text('Stok barang', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Masukkan stok barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Stok barang tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Stok barang harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _isLoading
              ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _saveForm, style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ), child: const Text('Simpan')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
