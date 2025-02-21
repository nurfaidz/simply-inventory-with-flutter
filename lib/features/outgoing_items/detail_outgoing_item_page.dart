import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/outgoing_item_provider.dart';
import 'package:provider/provider.dart';

class DetailOutgoingItemPage extends StatelessWidget {
  final String outgoingItemId;
  final String token;

  const DetailOutgoingItemPage({super.key, required this.outgoingItemId, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Barang Keluar'), centerTitle: true, automaticallyImplyLeading: false),
      body: FutureBuilder(
        future: Provider.of<OutgoingItemProvider>(context, listen: false).getOutgoingItemById(token, outgoingItemId),
        builder: (context, snapshot) {
          return Consumer<OutgoingItemProvider> (
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final outgoingItem = provider.outgoingItemDetail;

              if (outgoingItem == null) {
                return const Center(child: Text('Barang keluar tidak ditemukan'));
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        outgoingItem['products']['image_url'] ?? 'https://fakeimg.pl/150',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      outgoingItem['products']['name'] ?? '-',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Jumlah: ${outgoingItem['qty'] ?? 'Tidak tersedia'}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Tanggal: ${outgoingItem['outgoing_at'] ?? 'Tidak tersedia'}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 8),
                    Text(
                    outgoingItem['status'] == 'succeed' ? 'Sukses' : 'Dibatalkan',
                      style: TextStyle(
                        fontSize: 16,
                        color: outgoingItem['status'] == 'succeed' ? Colors.green : Colors.red,
                      ),
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
                                  '/outgoing-items/edit',
                                  arguments: {
                                    'outgoingItemId': outgoingItem['id'].toString(),
                                  },
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    ),
                  ],
                ),
              );
            }
          );
        }
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