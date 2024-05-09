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

 void fetchAndDisplayFifoList(List<String> uids) async {
  try {
    if (uids.isNotEmpty) {
      List<Map<String, dynamic>> list = await _fifoService.fetchRealtimeDatabaseDataForProduct(uids);
      setState(() {
        fifoList = list;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No UID found for the selected product.'),
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
  } on ProductNotFoundException catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(e.message),
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
  } on NoEntryDataException catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(e.message),
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
  } catch (e) {
    print("Error fetching FIFO list: $e");
    // Handle other exceptions
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to fetch FIFO data: $e'),
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

  Future<List<String>> getProductId(String productId) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Assigned_Products')
        .where('ProductId', isEqualTo: productId)
        .get();

    List<String> uids = [];
    snapshot.docs.forEach((doc) {
      uids.add(doc['UID']);
    });

    if (uids.isNotEmpty) {
      return uids;
    } else {
      print("No documents found in the snapshot for product ID: $productId");
    }
  } catch (e) {
    print("Error fetching UIDs: $e");
  }
  return [];
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
            List<String> uids = await getProductId(value!);
            if (uids.isNotEmpty) {
              fetchAndDisplayFifoList(uids);
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('No UID found for the selected product.'),
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
