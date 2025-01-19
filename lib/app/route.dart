import 'package:flutter/material.dart';
import '../features/homes/home_page.dart';
import '../features/products/product_page.dart';
import '../features/incoming_items/incoming_item_page.dart';
import '../features/outgoing_items/outgoing_item_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
        '/': (context) => const HomePage(),
        '/product': (context) => const ProductPage(),
        '/incoming': (context) => const IncomingItemPage(),
        '/outgoing': (context) => const OutgoingItemPage(),
      };
}
