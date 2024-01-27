import 'package:flutter/material.dart';
import 'package:smartinventory/screens/AddProductScreen.dart';
import 'package:smartinventory/services/ProductsService.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.indigo,
            onPrimary: Colors.white,
            padding: EdgeInsets.all(16.0),
          ),
        ),
      ),
      home: ProductsScreen(),
    );
  }
}

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
        title: Text('Products', style: TextStyle(fontSize: 24)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: navigateToAddProductForm,
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                onPrimary: Colors.white,
                padding: EdgeInsets.all(16.0),
              ),
              child: Text(
                'Add New Product',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: Card(
              margin: EdgeInsets.all(16.0),
              color: Colors.white,
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      records[index]['name'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'List Price: ${records[index]['list_price']}',
                      style: TextStyle(fontSize: 14),
                    ),
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
