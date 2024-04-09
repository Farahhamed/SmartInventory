import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  final TextEditingController productNameController;
  final TextEditingController listPriceController;
  final VoidCallback addProduct;

  const AddProductScreen({super.key, 
    required this.productNameController,
    required this.listPriceController,
    required this.addProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: productNameController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                labelText: 'Product Name',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: listPriceController,
              style: const TextStyle(fontSize: 18),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'List Price',
                labelStyle: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
           ElevatedButton(
              onPressed: addProduct,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.indigo, // Text color on button
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
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
