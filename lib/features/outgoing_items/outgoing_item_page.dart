import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/providers/outgoing_item_provider.dart';
import 'package:provider/provider.dart';

class OutgoingItemPage extends StatefulWidget {
  const OutgoingItemPage({super.key});

  @override
  _OutgoingItemPageState createState() => _OutgoingItemPageState();
}

class _OutgoingItemPageState extends State<OutgoingItemPage>{
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final outgoingItemProvider = Provider.of<OutgoingItemProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String token = authProvider.token!;
      outgoingItemProvider.getOutgoingItems(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Barang Keluar',
      style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color(0xFF2047A9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<OutgoingItemProvider>(
          builder: (context, outgoingItemProvider, _) {
            if (outgoingItemProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (outgoingItemProvider.outgoingItems.isEmpty) {
              return const Center(child: Text('Belum ada barang keluar', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              )));
            }

            return ListView.separated(
              itemCount: outgoingItemProvider.outgoingItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final outgoingItem = outgoingItemProvider.outgoingItems[index];
                return _buildOutgoingCard(
                  context: context,
                  outgoingItemId: outgoingItem['id'],
                  name: outgoingItem['products']['name'] ?? '-',
                  quantity: outgoingItem['qty'],
                  date: outgoingItem['outgoing_at'],
                  status: outgoingItem['status'],
                );
              },
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/outgoing-items/create');
        },
        backgroundColor: const Color(0xFF2047A9),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOutgoingCard({required BuildContext context, required int outgoingItemId, required String name, required int quantity, required String date, required String status}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Jumlah: $quantity', style: const TextStyle(color: Colors.grey)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(status == 'succeed' ? 'Sukses' : 'Dibatalkan', style: TextStyle(
              color: status == 'succeed' ? Colors.green : Colors.red,
            ),)
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/outgoing-items/show',
            arguments: {
              'token': Provider.of<AuthProvider>(context, listen: false).token,
          'outgoingItemId': outgoingItemId,
          }
          );
        },
      ),
    );
  }
}