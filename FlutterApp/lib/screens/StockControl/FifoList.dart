import 'package:flutter/material.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/services/FifoService.dart';
import 'package:smartinventory/services/ProductsService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSelectionPage extends StatefulWidget {
  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  String? selectedProduct;
  List<Product> productList = [];
  final ProductService _productService = ProductService();
  final FifoService _fifoService = FifoService();

  List<Map<String, dynamic>>? fifoList;

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

  void fetchAndDisplayFifoList(String tagUid) async {
    try {
      // Fetch the productId from Firestore based on the tagUid
      String productId = await getProductId(tagUid);
      if (productId.isNotEmpty) {
        // Fetch the FIFO list using the productId from the realtime database
        List<Map<String, dynamic>> list = await _fifoService.getFIFOListForProduct(productId);
        setState(() {
          fifoList = list;
        });
      } else {
        // Handle case where productId is not found
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Product not found for the given tag.'),
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
    } catch (e) {
      print("Error fetching FIFO list: $e");
      // Handle error
    }
  }

  Future<String> getProductId(String tagUid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('Assign_product')
          .where('tagUid', isEqualTo: tagUid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[0]['productId'];
      }
    } catch (e) {
      print("Error fetching productId: $e");
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Product'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedProduct,
            items: productList.map((product) {
              return DropdownMenuItem(child: Text(product.name), value: product.id);
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedProduct = value;
                fetchAndDisplayFifoList(value!);
              });
            },
          ),
          if (fifoList != null) ...[
            SizedBox(height: 20),
            Text('FIFO List for $selectedProduct'),
            Expanded(
              child: ListView.builder(
                itemCount: fifoList!.length,
                itemBuilder: (context, index) {
                  // Customize how each FIFO list entry is displayed based on your data structure
                  return ListTile(
                    title: Text('Entry Date: ${fifoList![index]['entryDate']}'),
                    subtitle: Text('Employee Name: ${fifoList![index]['employeeName']}'),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
