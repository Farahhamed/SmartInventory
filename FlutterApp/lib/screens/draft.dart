import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/services/ProductsService.dart'; // Import your ProductService

class ProductListScreen extends StatelessWidget {
  final ProductService _productService =
      ProductService(); // Create an instance of ProductService

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
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
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

void main() {
  runApp(MaterialApp(
    home: ProductListScreen(),
  ));
}
