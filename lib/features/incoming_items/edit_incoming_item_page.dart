import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/providers/incoming_item_provider.dart';
import 'package:provider/provider.dart';

class EditIncomingItemPage extends StatefulWidget {
  final String incomingItemId;

  const EditIncomingItemPage({super.key, required this.incomingItemId});

  @override
  _EditIncomingItemPageState createState() => _EditIncomingItemPageState();
}

class _EditIncomingItemPageState extends State<EditIncomingItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  DateTime? _selectedDate;
  final _quantityController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final incomingItemProvider =
        Provider.of<IncomingItemProvider>(context, listen: false);
    await incomingItemProvider.getIncomingItemById(token!, widget.incomingItemId);

    final incomingItem = incomingItemProvider.incomingItemDetail;

    if (incomingItem != null) {
      _quantityController.text = incomingItem['qty'].toString();
      _selectedDate = DateTime.parse(incomingItem['incoming_at']);
      _productController.text = incomingItem['products']['name'];
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateForm() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final formattedDate =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    final incomingItemProvider =
        Provider.of<IncomingItemProvider>(context, listen: false);
    bool success = await incomingItemProvider
        .updateIncomingItem(token!, widget.incomingItemId, {
      'user_id': authProvider.user!['id'],
      'qty': int.tryParse(_quantityController.text) ?? 0,
      'incoming_at': formattedDate,
    });

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil mengubah barang masuk')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah barang masuk')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context).token;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Barang Masuk'), centerTitle: true, automaticallyImplyLeading: false),
      body: FutureBuilder(
        future: Provider.of<IncomingItemProvider>(context, listen: false)
            .getIncomingItemById(token!, widget.incomingItemId),
        builder: (context, snapshot) {
          return Consumer<IncomingItemProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final incomingItem = provider.incomingItemDetail;

              if (incomingItem == null) {
                return const Center(
                    child: Text('Barang masuk tidak ditemukan'));
              }

              _quantityController.text = incomingItem['qty'].toString();

              _productController.text = incomingItem['products']['name'];

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text('Nama Barang', style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: _productController,
                        keyboardType: TextInputType.text,
                        enabled: false,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      Text('Jumlah Barang',
                          style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Masukan jumlah barang',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan jumlah barang';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Masukkan jumlah barang dengan benar';
                            }

                            return null;
                          }),
                      const SizedBox(height: 16),
                      Text('Tanggal Masuk',
                          style: Theme.of(context).textTheme.titleMedium),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            hintText: 'Pilih Tanggal Masuk',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _selectedDate != null
                                ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                                : "Pilih Tanggal",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _updateForm,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40),
                              ),
                              child: const Text('Ubah'),
                            )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
