import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/providers/incoming_item_provider.dart';
import 'package:flutter_inventory_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class CreateIncomingItemPage extends StatefulWidget {
  const CreateIncomingItemPage({super.key});

  @override
  _CreateIncomingItemPageState createState() => _CreateIncomingItemPageState();
}

class _CreateIncomingItemPageState extends State<CreateIncomingItemPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedItem;
  DateTime? _selectedDate;
  final TextEditingController _quantityController = TextEditingController();
  bool _isLoading = false;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    final incomingItemProvider = Provider.of<IncomingItemProvider>(context, listen: false);
    bool success = await incomingItemProvider.createIncomingItem(token!, {
      'user_id': authProvider.user!['id'],
      'product_id': int.tryParse(_selectedItem!) ?? 0,
      'qty': int.tryParse(_quantityController.text) ?? 0,
      'incoming_at': formattedDate,
    });

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/incoming-items');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barang masuk berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan barang masuk')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final products = Provider.of<ProductProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String token = authProvider.token!;
      products.getProducts(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang Masuk'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Barang', style: Theme.of(context).textTheme.titleMedium),
              DropdownButtonFormField<String>(
                value: _selectedItem,
                items: productProvider.products.map<DropdownMenuItem<String>>((product) {
                  return DropdownMenuItem<String>(
                    value: product['id'].toString(),
                    child: Text(product['name'] ?? '-'),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedItem = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih barang' : null,
              ),
              const SizedBox(height: 16),
              Text('Jumlah Barang', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Masukkan jumlah barang'),
                validator: (value) => (value == null || value.isEmpty) ? 'Masukkan jumlah barang' : null,
              ),
              const SizedBox(height: 16),
              Text('Tanggal Masuk', style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                            : '',
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Pilih tanggal',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context),
                      validator: (value) => _selectedDate == null ? 'Pilih tanggal' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
             _isLoading
              ? const CircularProgressIndicator()
                 : ElevatedButton(onPressed: _saveForm,  style: ElevatedButton.styleFrom(
               minimumSize: const Size(double.infinity, 40),
             ), child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
