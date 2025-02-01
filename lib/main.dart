import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inventory_app/app/route.dart';
import 'package:flutter_inventory_app/providers/auth_provider.dart';
import 'package:flutter_inventory_app/providers/incoming_item_provider.dart';
import 'package:flutter_inventory_app/providers/outgoing_item_provider.dart';
import 'package:flutter_inventory_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  debugPaintSizeEnabled = false;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => IncomingItemProvider()),
      ChangeNotifierProvider(create: (_) => OutgoingItemProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Inventory',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: AppRoutes.routes,
    );
  }
}
