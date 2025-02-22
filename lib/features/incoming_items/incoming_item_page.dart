import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/providers/incoming_item_provider.dart';
import 'package:provider/provider.dart';

class IncomingItemPage extends StatefulWidget {
  const IncomingItemPage({super.key});

  @override
  _IncomingItemPageState createState() => _IncomingItemPageState();
}

class _IncomingItemPageState extends State<IncomingItemPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final incomingItemProvider =
          Provider.of<IncomingItemProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String token = authProvider.token!;
      incomingItemProvider.getIncomingItems(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang Masuk',
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
        child: Consumer<IncomingItemProvider>(
            builder: (context, incomingItemProvider, _) {
          if (incomingItemProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (incomingItemProvider.incomingItems.isEmpty) {
            return const Center(
                child: Text(
              'Belum ada barang masuk',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ));
          }

          return ListView.separated(
            itemCount: incomingItemProvider.incomingItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final incomingItem = incomingItemProvider.incomingItems[index];
              return _buildIncomingCard(
                context: context,
                incomingItemId: incomingItem['id'],
                name: incomingItem['products']['name'] ?? '-',
                quantity: incomingItem['qty'],
                date: incomingItem['incoming_at'],
                status: incomingItem['status'],
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/incoming-items/create');
        },
        backgroundColor: const Color(0xFF2047A9),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildIncomingCard(
      {required BuildContext context,
      required int incomingItemId,
      required String name,
      required int quantity,
      required String status,
      required String date}) {
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
        subtitle: Text('Jumlah: $quantity',
            style: const TextStyle(color: Colors.grey)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              status == 'succeed' ? 'Sukses' : 'Dibatalkan',
              style: TextStyle(
                color: status == 'succeed' ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/incoming-items/show', arguments: {
            'incomingItemId': incomingItemId,
            'token': Provider.of<AuthProvider>(context, listen: false).token,
          });
        },
      ),
    );
  }
}
