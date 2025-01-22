import 'package:flutter/material.dart';

class IncomingItemPage extends StatelessWidget {
  const IncomingItemPage({super.key});

  final List<Map<String, String>> incoming_items = const [
    {
      'name': 'Barang Masuk 1',
      'quantity': '10',
      'total': 'Rp 1.000.000',
      'date': '2021-10-10',
      'status': 'Diterima',
    },
    {
      'name': 'Barang Masuk 2',
      'quantity': '20',
      'total': 'Rp 2.000.000',
      'date': '2021-10-11',
      'status': 'Diterima',
    },
    {
      'name': 'Barang Masuk 3',
      'quantity': '30',
      'total': 'Rp 3.000.000',
      'date': '2021-10-12',
      'status': 'Diterima',
    },
    {
      'name': 'Barang Masuk 4',
      'quantity': '40',
      'total': 'Rp 4.000.000',
      'date': '2021-10-13',
      'status': 'Diterima',
    },
    {
      'name': 'Barang Masuk 5',
      'quantity': '50',
      'total': 'Rp 5.000.000',
      'date': '2021-10-14',
      'status': 'Diterima',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('Daftar Barang Masuk'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: incoming_items.length,
            itemBuilder: (context, index) {
              final incoming_item = incoming_items[index];
              return _buildIncomingCard(
                name: incoming_item['name']!,
                quantity: incoming_item['quantity']!,
                total: incoming_item['total']!,
                date: incoming_item['date']!,
                status: incoming_item['status']!,
              );
            },
          ),
        ));
  }

  Widget _buildIncomingCard(
      {required String name,
      required String quantity,
      required String total,
      required String date,
      required String status}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(total, style: const TextStyle(color: Colors.grey)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(status, style: const TextStyle(color: Colors.green)),
          ],
        ),
        onTap: () {
          print('Tapped $name');
        },
      ),
    );
  }
}
