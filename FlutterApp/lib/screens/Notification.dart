import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smartinventory/firebase_options.dart';
import 'package:smartinventory/providers/provider.dart';
import 'package:smartinventory/services/ProductsService.dart';

class NotificationPage extends StatelessWidget {
  final ProductService _productService = ProductService();
  int desiredInventoryLevel = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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

          // Filter products based on purchase limit and quantity
          final filteredProducts = products.where((product) {
            int currentInventoryLevel = product['quantity'];
            int purchaseLimit = calculatePurchaseLimit(
                desiredInventoryLevel, currentInventoryLevel);
            print(
                'Product: ${product['name']}, Quantity: $currentInventoryLevel, Purchase Limit: $purchaseLimit');
            return currentInventoryLevel <
                purchaseLimit; // Corrected comparison
          }).toList();

          if (filteredProducts.isEmpty) {
            return Center(child: Text('No products below purchase limit.'));
          }

          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              // Check if product has reached purchase limit
              bool reachedPurchaseLimit = product['quantity'] >=
                  calculatePurchaseLimit(
                      desiredInventoryLevel, product['quantity']);
              String content = reachedPurchaseLimit
                  ? 'The product ${product['name']} reached the purchase limit. Current quantity is ${product['quantity']}. Please restock.'
                  : 'The product ${product['name']} reached the purchase limit. Current quantity is ${product['quantity']}. Please restock.';
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ProductCard(
                  title: product['name'],
                  content: content,
                  icon: Icons.warning,
                  iconColor: Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/*-----------------------this is the purchase limit part-------------------------*/
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
      home: NotificationPage(),
    ),
  ));
}

/*------------------- product card-----------------------------------------*/

class ProductCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String content;

  const ProductCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Text(content),
      ),
    );
  }
}
