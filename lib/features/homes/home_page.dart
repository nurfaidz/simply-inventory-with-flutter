import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Simple Inventory')),
        body: Center(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: [
              _buildMenuItem(
                context,
                icon: Icons.list,
                label: 'Produk',
                route: '/products',
              ),
              _buildMenuItem(context,
                  icon: Icons.input,
                  label: 'Barang Masuk',
                  route: '/incoming-items'),
              _buildMenuItem(context,
                  icon: Icons.output,
                  label: 'Barang Keluar',
                  route: '/outgoing-items'),
              _buildMenuItem(context,
                  icon: Icons.logout, label: 'Logout', route: '/login'),
            ],
          ),
        ));
  }
}

Widget _buildMenuItem(BuildContext context,
    {required icon, required String label, required String route}) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, route),
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ),
  );
}
