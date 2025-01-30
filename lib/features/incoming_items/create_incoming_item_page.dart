import 'package:flutter/material.dart';

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
  final TextEditingController _noteController = TextEditingController();

  final List<String> items = ['Barang A', 'Barang B', 'Barang C', 'Barang D', 'Barang E'];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101),);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang Masuk'), centerTitle: true),
      body:  Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Barang', style: Theme.of(context).textTheme.titleMedium),
              DropdownButtonFormField<String>(
                value: _selectedItem,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
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
              Text('Pilih Tanggal', style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text:  _selectedDate != null
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
              const SizedBox(height: 16),
              Text('Jumlah Barang', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Masukan jumlah'),
                validator: (value) => (value == null || value.isEmpty) ? 'Masukan jumlah barang' : null,
              ),
              const SizedBox(height: 16),
              Text('Catatan', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Masukan catatan(opsional)'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Simpan'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}