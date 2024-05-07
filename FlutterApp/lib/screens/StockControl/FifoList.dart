import 'package:flutter/material.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/services/FifoService.dart';
import 'package:smartinventory/services/ProductsService.dart';

class ProductSelectionPage extends StatefulWidget {
  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  String? selectedProduct;
  List<Product> productList = [];
  final ProductService _productService = ProductService();
  final FifoService _fifoService = FifoService(); // Create an instance of FifoService

  @override
  void initState() {
    super.initState();
    fetchProductList();
  }

 void fetchProductList() async {
  try {
    _productService.getProduct().listen((List<Product> products) {
      setState(() {
        productList = products;
      });
    });
  } catch (e) {
    print("Error fetching product list: $e");
    // Display an error message to the user
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to fetch product list. Please try again later.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

  void showFifoList() async {
    if (selectedProduct != null) {
      List<Map<String, dynamic>> fifoList = await _fifoService.getFIFOListForProduct(selectedProduct!);
      List<String> fifoStringList = fifoList.map((entry) => entry.toString()).toList(); // Modify this line to extract the strings you need
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('FIFO List for $selectedProduct'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fifoStringList.map((entry) => Text(entry)).toList(), // Use the modified list here
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select a product first.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Product'),
      ),
      body: Column(
        children: [
          FutureBuilder<List<String>>(
  future: _productService.getAssignedProductIds(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      List<String> assignedProductIds = snapshot.data ?? [];
      List<Future<Product>> assignedProductFutures = assignedProductIds.map((productId) => _productService.getProductById(productId)).toList();

      return FutureBuilder<List<Product>>(
        future: Future.wait(assignedProductFutures),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Product> assignedProducts = snapshot.data ?? [];
            return DropdownButton<String>(
              value: selectedProduct,
              items: assignedProducts.map((product) {
                return DropdownMenuItem(child: Text(product.name), value: product.id);
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                });
              },
            );
          }
        },
      );
    }
  },
),
          ElevatedButton(
            onPressed: showFifoList,
            child: Text('Show FIFO List'),
          ),
        ],
      ),
    );
  }
}
