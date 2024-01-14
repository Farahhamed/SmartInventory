import 'package:flutter/material.dart';
import 'package:smartinventory/screens/AddProductScreen.dart';
import 'package:smartinventory/services/ProductsService.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter + Flask API'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: navigateToAddProductForm,
              child: Text('Add New Product'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(records[index]['name']),
                  subtitle: Text('List Price: ${records[index]['list_price']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
