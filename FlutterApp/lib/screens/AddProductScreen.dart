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
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Product Name',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: listPriceController,
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'List Price',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
           ElevatedButton(
              onPressed: addProduct,
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo, // Button color
                onPrimary: Colors.white, // Text color on button
                padding: EdgeInsets.all(16.0),
              ),
              child: Text(
                'Add New Product',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
