import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smartinventory/firebase_options.dart';
import 'package:smartinventory/providers/provider.dart';
import 'package:smartinventory/services/ProductsService.dart';

class ProductListScreen extends StatelessWidget {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _productService.getProductNamesAndQuantities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data;
          if (products == null || products.isEmpty) {
            return Center(child: Text('No products found.'));
          }
          // Filter products based on quantity less than purchase limit
          final filteredProducts = products
              .where((product) =>
                  product['quantity'] <
                  calculatePurchaseLimit(
                      desiredInventoryLevel, product['quantity']))
              .toList();

          if (filteredProducts.isEmpty) {
            return Center(
                child: Text(
                    'No products with quantity less than purchase limit.'));
          }

          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return ListTile(
                title: Text(product['name']),
                subtitle: Text('Quantity: ${product['quantity']}'),
              );
            },
          );
        },
      ),
    );
  }
}

/*-----------------------this is the purchase limit part-------------------------*/
int desiredInventoryLevel = 50;

int calculatePurchaseLimit(
    int desiredInventoryLevel, int currentInventoryLevel) {
  int purchaseLimit = desiredInventoryLevel - currentInventoryLevel;
  return purchaseLimit < 0 ? 0 : purchaseLimit;
}

/*----------------------------------------------------------------------------------------------*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductListScreen(),
    ),
  ));
}
