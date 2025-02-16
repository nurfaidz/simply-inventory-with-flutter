import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/incoming_item_provider.dart';
import 'package:provider/provider.dart';

class DetailIncomingItemPage extends StatelessWidget {
  final String incomingItemId;
  final String token;

  const DetailIncomingItemPage({super.key, required this.incomingItemId, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Detail Barang Masuk'), centerTitle: true),
      body: FutureBuilder(
        future: Provider.of<IncomingItemProvider>(context, listen: false).getIncomingItemById(token, incomingItemId),
        builder: (context, snapshot) {
          return Consumer<IncomingItemProvider> (
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final incomingItem = provider.incomingItemDetail;

              if (incomingItem == null) {
                return const Center(child: Text('Barang masuk tidak ditemukan'));
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Center(
                       child: Image.network(
                          incomingItem['products']['image_url'] ?? 'https://fakeimg.pl/150',
                          width: 150,
                          height: 150,
                       ),
                     ) ,
                      const SizedBox(height: 16),
                      Text(
                        incomingItem['products']['name'] ?? '-',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Jumlah: ${incomingItem['qty'] ?? 'Tidak tersedia'}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Tanggal: ${incomingItem['incoming_at'] ?? 'Tidak tersedia'}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),

                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/incoming-items/edit',
                                    arguments: {
                                      'incomingItemId': incomingItem['id'].toString(),
                                    }
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                  )
                                ),
                                child: const Text('Ubah', style: TextStyle(fontSize: 16, color: Colors.black)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _showDeleteDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Batalkan', style: TextStyle(fontSize: 16, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                ),
              );
            },
          );
        }
      )
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
