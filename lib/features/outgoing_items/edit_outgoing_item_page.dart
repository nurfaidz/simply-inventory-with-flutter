import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/providers/outgoing_item_provider.dart';
import 'package:provider/provider.dart';

class EditOutgoingItemPage extends StatefulWidget {
  final String outgoingItemId;

  const EditOutgoingItemPage({super.key, required this.outgoingItemId});

  @override
  _EditOutgoingItemPageState createState() => _EditOutgoingItemPageState();
}

class _EditOutgoingItemPageState extends State<EditOutgoingItemPage> {
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
    final outgoingItemProvider = Provider.of<OutgoingItemProvider>(context, listen: false);
    await outgoingItemProvider.getOutgoingItemById(token!, widget.outgoingItemId);

    final outgoingItem = outgoingItemProvider.outgoingItemDetail;

    if (outgoingItem != null) {
      _quantityController.text = outgoingItem['qty'].toString();
      _selectedDate = DateTime.parse(outgoingItem['outgoing_at']);
      _productController.text = outgoingItem['products']['name'];
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101)
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
    final formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    final outgoingItemProvider = Provider.of<OutgoingItemProvider>(context, listen: false);
    bool success = await outgoingItemProvider.updateOutgoingItem(token!, widget.outgoingItemId, {
      'user_id': authProvider.user!['id'],
      'qty': int.tryParse(_quantityController.text) ?? 0,
      'outgoing_at': formattedDate,
    });

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil mengubah barang keluar')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah barang keluar')),
      );
    }
   }

   @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context).token;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Barang Keluar'), centerTitle: true),
      body: FutureBuilder(
        future: Provider.of<OutgoingItemProvider>(context, listen: false).getOutgoingItemById(token!, widget.outgoingItemId),
        builder: (context, snapshot) {
          return Consumer<OutgoingItemProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final outgoingItem = provider.outgoingItemDetail;

              if (outgoingItem == null) {
                return const Center(child: Text('Barang keluar tidak ditemukan'));
              }

              _quantityController.text = outgoingItem['qty'].toString();
              _productController.text = outgoingItem['products']['name'];
              
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
                      Text('Jumlah Barang', style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Masukan jumlah barang',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan jumlah barang';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Tanggal Keluar', style: Theme.of(context).textTheme.titleMedium),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            hintText: 'Pilih Tanggal Keluar',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(_selectedDate != null
                          ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                          : "Pilih Tanggal",
                          style: const TextStyle(fontSize: 16),),
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
                        child:  const Text('Ubah'),
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