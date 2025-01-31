import 'package:flutter/material.dart';

class DetailIncomingItemPage extends StatelessWidget {
  const DetailIncomingItemPage({super.key});

  final incoming_item = const {
    'name': 'Barang Masuk 1',
    'quantity': '10',
    'total': 'Rp 1.000.000',
    'date': '2021-10-10',
    'status': 'Diterima',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Detail Barang Masuk'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              incoming_item['name']!,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Jumlah: ${incoming_item['quantity']}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              incoming_item['total']!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              incoming_item['date']!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              incoming_item['status']!,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Hapus Barang Masuk', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Hapus Barang Masuk'),
      content:  const Text('Apakah Anda yakin ingin menghapus barang masuk ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Barang masuk telah dihapus')),
            );
          },
          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
        ),
      ],
    )
  );
}
