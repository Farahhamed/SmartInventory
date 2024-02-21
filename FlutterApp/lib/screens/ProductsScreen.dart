import 'package:flutter/material.dart';
import 'package:smartinventory/screens/AddProductScreen.dart';
import 'package:smartinventory/screens/EditProductScreen.dart';
import 'package:smartinventory/services/ProductsService.dart';

enum UserType { Manager, Employee }

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key, required this.userType}) : super(key: key);
  final UserType userType;

  @override
  _OdooMethodsViewState createState() => _OdooMethodsViewState();
}

class _OdooMethodsViewState extends State<ProductsScreen> {
  List<Map<String, dynamic>> records = [];
  final ProductService odooMethodsHelper = ProductService();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController listPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await odooMethodsHelper.fetchData();
    setState(() {
      records = data;
    });
  }

  Future<void> addProduct() async {
    await odooMethodsHelper.addProduct(
      productNameController.text,
      double.parse(listPriceController.text),
    );
    fetchData(); // Refresh data after adding a product
    Navigator.pop(context); // Close the Add Product form after adding
  }

  Future<void> updateProduct(int productId, String newName, double newListPrice) async {
    await odooMethodsHelper.updateProduct(productId, newName, newListPrice);
    fetchData(); // Refresh data after updating the product
  }

  void navigateToAddProductForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(
          productNameController: productNameController,
          listPriceController: listPriceController,
          addProduct: addProduct,
        ),
      ),
    );
  }

  void editProduct(int productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          productId: productId,
          updateProduct: updateProduct,
        ),
      ),
    );
  }

  void performDelete(int productId) async {
  try {
    await odooMethodsHelper.deleteProduct(productId);
    fetchData(); // Refresh data after deleting the product
  } catch (error) {
    print('Error deleting product: $error');
    // Handle error cases or display a message to the user
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products', style: TextStyle(fontSize: 24)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.userType == UserType.Manager)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: navigateToAddProductForm,
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                onPrimary: Colors.white,
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Add New Product',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      records[index]['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'List Price: ${records[index]['list_price']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: widget.userType == UserType.Manager ?Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => editProduct(records[index]['id']),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                          ),
                          child: const Text('Edit'),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () => performDelete(records[index]['id']),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ): null,
                    
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
