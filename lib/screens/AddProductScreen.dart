import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  final TextEditingController productNameController;
  final TextEditingController listPriceController;
  final VoidCallback addProduct;

  AddProductScreen({
    required this.productNameController,
    required this.listPriceController,
    required this.addProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: listPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'List Price'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
