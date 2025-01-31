import 'package:flutter/material.dart';

class DetailOutgoingItemPage extends StatelessWidget {
  const DetailOutgoingItemPage({super.key});

  final outgoing_item = const {
    'name': 'Barang Keluar 1',
    'quantity': '10',
    'total': 'Rp 1.000.000',
    'date': '2021-10-10',
    'status': 'Diterima',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Barang Keluar'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              outgoing_item['name']!,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Jumlah: ${outgoing_item['quantity']}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            Text(
              outgoing_item['total']!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            Text(
              outgoing_item['date']!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            Text(
              outgoing_item['status']!,
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
                  padding: const EdgeInsets.symmetric(vertical: 14)
                ),
                child: const Text('Hapus Barang Keluar', style: TextStyle(fontSize: 16, color: Colors.white)),
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
    title: const Text('Hapus Barang Keluar'),
    content: const Text('Apakah Anda yakin ingin menghapus barang keluar ini?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Barang keluar telah dihapus')),
          );
        },
        child: const Text('Hapus', style: TextStyle(color: Colors.red)),
      ),
    ],
  )
  );
}