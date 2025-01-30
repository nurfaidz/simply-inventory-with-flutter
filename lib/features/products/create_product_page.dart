import 'package:flutter/material.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk'), centerTitle: true),
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
              Text('Harga barang', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Masukkan harga barang'),
                validator: (value) => (value == null || value.isEmpty) ? 'Harga barang tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              Text('Stok barang', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Masukkan stok barang'),
                validator: (value) => (value == null || value.isEmpty) ? 'Stok barang tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
