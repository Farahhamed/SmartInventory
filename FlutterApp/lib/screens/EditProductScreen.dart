import 'package:flutter/material.dart';
import 'package:smartinventory/models/ProductModel.dart';

class EditProductScreen extends StatelessWidget {
  final Product product; // Pass the entire Product object
  final Function(Product) updateProduct; // Modify the function signature

  EditProductScreen({
    Key? key,
    required this.product, // Update the constructor
    required this.updateProduct,
  }) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text =
        product.name; // Pre-fill the text fields with existing data
    quantityController.text = product.quantity.toString();
    descriptionController.text = product.description;
    priceController.text = product.price;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Create a new Product object with updated data but keep the original orderDateTime
                Product updatedProduct = Product(
                  name: nameController.text,
                  quantity: int.parse(quantityController.text),
                  description: descriptionController.text,
                  price: priceController.text,
                  categoryId: product.categoryId,
                  imageUrl: product.imageUrl,
                  id: product.id,
                  orderDateTime: product.orderDateTime,
                  discountApplied: false,
                );
                // Pass the updated Product to the updateProduct method
                updateProduct(updatedProduct);
                Navigator.pop(
                    context); // Close the Edit Product form after updating
              },
              child: const Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
