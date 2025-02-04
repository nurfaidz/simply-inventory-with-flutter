import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    setState(() => _isLoading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      setState(() => _isLoading = false);
      
      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil, silahkan login')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi gagal, coba lagi')),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(onPressed: _register,
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: const Text('Register'),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/login');
              }, child: const Text('Sudah punya akun? Login disini', style: TextStyle(color: Colors.blue)),)
          ],
        ),
      ),
    );
  }
}