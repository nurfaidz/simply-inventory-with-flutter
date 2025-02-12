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
      appBar: AppBar(title: const Text('Daftar Barang Keluar'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Consumer<OutgoingItemProvider>(
          builder: (context, outgoingItemProvider, _) {
            if (outgoingItemProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (outgoingItemProvider.outgoingItems.isEmpty) {
              return const Center(child: Text('Belum ada barang keluar'));
            }

            return ListView.builder(
              itemCount: outgoingItemProvider.outgoingItems.length,
              itemBuilder: (context, index) {
                final outgoingItem = outgoingItemProvider.outgoingItems[index];
                return _buildOutgoingCard(
                  context: context,
                  outgoingItemId: outgoingItem['id'],
                  name: outgoingItem['products']['name'] ?? '-',
                  quantity: outgoingItem['qty'],
                  date: outgoingItem['outgoing_at'],
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOutgoingCard({required BuildContext context, required int outgoingItemId, required String name, required int quantity, required String date}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
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
            Text('Diterima', style: const TextStyle(color: Colors.green)),
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