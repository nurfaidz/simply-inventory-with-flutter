import 'package:flutter/material.dart';
import 'package:flutter_inventory_app/features/incoming_items/edit_incoming_item_page.dart';
import 'package:flutter_inventory_app/features/products/edit_product_page.dart';
import 'package:flutter_inventory_app/features/screens/profile_page.dart';
import '../features/homes/home_page.dart';
import '../features/products/product_page.dart';
import '../features/products/create_product_page.dart';
import '../features/products/product_detail_page.dart';
import '../features/incoming_items/incoming_item_page.dart';
import '../features/incoming_items/create_incoming_item_page.dart';
import '../features/incoming_items/detail_incoming_item_page.dart';
import '../features/outgoing_items/outgoing_item_page.dart';
import '../features/outgoing_items/create_outgoing_item_page.dart';
import '../features/outgoing_items/detail_outgoing_item_page.dart';
import '../features/auths/login_page.dart';
import '../features/auths/registration_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
        '/': (context) => const HomePage(),

        // Product
        '/products': (context) => const ProductPage(),
        '/products/create': (context) => const CreateProductPage(),
        '/products/show': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return ProductDetailPage(productId: args['productId'].toString(), token: args['token'] as String);
        },
        '/products/edit': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return EditProductPage(productId: args['productId'].toString());
        },

        // Incoming Item
        '/incoming-items': (context) => const IncomingItemPage(),
        '/incoming-items/create': (context) => const CreateIncomingItemPage(),
        '/incoming-items/show': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return DetailIncomingItemPage(incomingItemId: args['incomingItemId'].toString(), token: args['token'] as String);
        },
        '/incoming-items/edit': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return EditIncomingItemPage(incomingItemId: args['incomingItemId'].toString());
        },

        // Outgoing Item
        '/outgoing-items': (context) => const OutgoingItemPage(),
        '/outgoing-items/create': (context) => const CreateOutgoingItemPage(),
        '/outgoing-items/show': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return DetailOutgoingItemPage(outgoingItemId: args['outgoingItemId'].toString(), token: args['token'] as String);
        },

        // Auth
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),

        // Profile
        '/profile': (context) => const ProfilePage(),
      };
}
