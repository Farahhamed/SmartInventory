import 'package:flutter/material.dart';
import 'package:smartinventory/services/ProductsService.dart';

class EditProductScreen extends StatelessWidget {
  final int productId;
  final Function(int, String, double) updateProduct;

  EditProductScreen({
    required this.productId,
    required this.updateProduct,
  });

  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newListPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: newNameController,
              decoration: InputDecoration(labelText: 'New Product Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: newListPriceController,
              decoration: InputDecoration(labelText: 'New List Price'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                updateProduct(
                  productId,
                  newNameController.text,
                  double.parse(newListPriceController.text),
                );
                Navigator.pop(context); // Close the Edit Product form after updating
              },
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
