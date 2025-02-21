import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Simple Inventory'),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/images/user.png'),
              radius: 20,
            ),
          )
        )
      ]
    );
  }
}