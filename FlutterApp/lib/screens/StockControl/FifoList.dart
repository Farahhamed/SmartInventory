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
      // Handle error
    }
  }

void fetchAndDisplayFifoList(String uid) async {
  try {
    // Fetch the UID from Firestore based on the productId
    if (uid.isNotEmpty) {
      // Fetch the FIFO list using the UID from the real-time database
      List<Map<String, dynamic>> list = await _fifoService.fetchRealtimeDatabaseDataForProduct(uid);
      setState(() {
        fifoList = list;
      });
    } else {
      // Handle case where UID is not found
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('UID not found for the selected product.'),
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



  Future<String> getProductId(String productId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Assigned_Products')
          .where('ProductId', isEqualTo: productId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print("Snapshot data: ${snapshot.docs[0].data()}");
        return snapshot.docs[0]['UID'];
      } else {
        print("No documents found in the snapshot for product ID: $productId");
      }
    } catch (e) {
      print("Error fetching UID: $e");
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
              return DropdownMenuItem(
                  child: Text(product.name), value: product.id);
            }).toList(),
            onChanged: (value) async {
              setState(() {
                selectedProduct = value;
              });
              // Fetch UID based on selected product ID
              String uid = await getProductId(value!);
              if (uid.isNotEmpty) {
                // Fetch and display FIFO list using UID
                fetchAndDisplayFifoList(uid);
              } else {
                // Handle case where UID is not found
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text('UID n.'),
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
                    title: Text('Entry Date: ${fifoList![index]['datetime']}'),
                    subtitle: Text('Other details here...'),
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
