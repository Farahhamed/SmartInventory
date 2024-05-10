import 'package:flutter/material.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/services/FifoService.dart';
import 'package:smartinventory/services/ProductsService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIFO Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FIFOInventoryPage(),
    );
  }
}

class ProductCategory {
  final String name;

  ProductCategory(this.name);
}

class FIFOInventoryPage extends StatefulWidget {
  @override
  _FIFOInventoryPageState createState() => _FIFOInventoryPageState();
}

class _FIFOInventoryPageState extends State<FIFOInventoryPage> {
  String? selectedProduct;
  List<Product> productList = [];
  final ProductService _productService = ProductService();
  final FifoService _fifoService = FifoService();

  List<Map<String, dynamic>>? fifoList;

  // Dummy product details
  String _productName = '';
  String _productTagNumber = '';
  String _dateOfEntry = '';
  String _dateOfExit = '';
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
        List<Map<String, dynamic>> list =
            await _fifoService.fetchRealtimeDatabaseDataForProduct(uids);
        setState(() {
          fifoList = list;

          // Update product name based on the selected product from the dropdown list
          final _selectedProduct = productList
              .firstWhere((product) => product.id == selectedProduct);
          _productName = _selectedProduct.name;

          // Leave other fields as static for now
          _productTagNumber = fifoList![0]['taguid'];
          _dateOfEntry = fifoList![0]['datetime'];
          _dateOfExit = '';
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
        title: Text('FIFO Inventory'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose a product to display FIFO:",
                style: TextStyle(
                    fontSize: 17, color: Color.fromRGBO(19, 93, 102, 1)),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Products',
                  hintText: 'Choose a products',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  contentPadding: const EdgeInsets.only(left: 20, right: 12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFBB8493),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFBB8493),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: selectedProduct,
                items: productList.map((product) {
                  return DropdownMenuItem(
                      child: Text(product.name), value: product.id);
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedProduct = value;

                    // Reset product details when changing the category
                    _productName = '';
                    _productTagNumber = '';
                    _dateOfEntry = '';
                    _dateOfExit = '';
                  });
                  List<String> uids = await getProductId(value!);
                  if (uids.isNotEmpty) {
                    fetchAndDisplayFifoList(uids);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Sorry'),
                        content: Text('There is no stock of this product in the inventory.'),
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
              SizedBox(height: 50),
              if (fifoList != null && fifoList!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          size: 32,
                          color: Color.fromRGBO(19, 93, 102, 1),
                        ),
                        SizedBox(width: 10),
                        //product name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product Name: ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(219, 175, 160, 1)),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _productName,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //tag number
                    // SizedBox(height: 30),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.confirmation_number,
                    //       size: 30,
                    //       color: Color.fromRGBO(19, 93, 102, 1),
                    //     ),
                    //     SizedBox(width: 10),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Product Tag Number: ",
                    //           style: TextStyle(
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.bold,
                    //               color: Color.fromRGBO(219, 175, 160, 1)),
                    //         ),
                    //         Text(
                    //           _productTagNumber,
                    //           style: TextStyle(fontSize: 16),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 30),
                    //date of entry list
                    // Adjusted "Date of Entry to Inventory" section
                    // Adjusted "Date of Entry to Inventory" section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 30,
                              color: Color.fromRGBO(19, 93, 102, 1),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "FIFO results for this product:  ",

//                               "Stock Arrival Date(s)",
// >>>>>>> master
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(219, 175, 160, 1),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        if (fifoList != null && fifoList!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: fifoList!.map((entry) {
                              return Padding(
                                padding: EdgeInsets.only(left: 40, top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Date: ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromRGBO(
                                                  155, 190, 200, 1),
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${entry['datetime']}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Tag: ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromRGBO(
                                                  155, 190, 200, 1),
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${entry['taguid']}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),

                    SizedBox(height: 30),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.inventory_sharp,
                    //       size: 30,
                    //       color: Color.fromRGBO(19, 93, 102, 1),
                    //     ),
                    //     SizedBox(width: 10),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Date of Exit from Inventory: ",
                    //           style: TextStyle(
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.bold,
                    //               color: Color.fromRGBO(219, 175, 160, 1)),
                    //         ),
                    //         Text(
                    //           "12/4/2024",
                    //           style: TextStyle(fontSize: 16),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
