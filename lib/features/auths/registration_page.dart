import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

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
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            }, style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ), child: const Text('Register'),),
            const SizedBox(height: 16),
            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/login');
              }, child: const Text('Already have an account? Login here', style: TextStyle(color: Colors.blue),),)
          ],
        ),
      ),
    );
  }
}