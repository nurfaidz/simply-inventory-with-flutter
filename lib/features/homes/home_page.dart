import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/widgets/header_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  void _logout() async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.logout();

    if (success) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button
        title: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: HeaderWidget(),
        ),
        backgroundColor: const Color(0xFF2047A9),
      ),
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
                icon: Icons.logout, label: 'Logout', onTap: _logout, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}

Widget _buildMenuItem(BuildContext context,
    {required IconData icon, required String label, String? route, VoidCallback? onTap, bool isLoading = false}) {
  return GestureDetector(
    onTap: onTap ?? () => Navigator.pushNamed(context, route!),
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2047A9), Color(0xFF102B75)],
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
          isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Icon(icon, size: 48, color: Colors.white),
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
