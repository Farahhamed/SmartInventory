// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartinventory/services/ProductsService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/screens/AddProductScreen.dart';
import 'package:smartinventory/screens/EditProductScreen.dart';

enum UserType { Manager, Employee }

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  List<Map<String, dynamic>> records = [];
  final ProductService odooMethodsHelper = ProductService();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController listPriceController = TextEditingController();
  UserType _userType = UserType.Employee;

  @override
  void initState() {
    super.initState();
    _getUserType();
    fetchData();
  }

  Future<void> _getUserType() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        dynamic userData = userSnapshot.data();
        String? userType = userData?['userType'] as String?;

        if (userType == 'Manager') {
          setState(() {
            _userType = UserType.Manager;
          });
        } else {
          setState(() {
            _userType = UserType.Employee;
          });
        }
      }
    }
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
    fetchData();
    Navigator.pop(context);
  }

  Future<void> updateProduct(int productId, String newName, double newListPrice) async {
    await odooMethodsHelper.updateProduct(productId, newName, newListPrice);
    fetchData();
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
      fetchData();
    } catch (error) {
      print('Error deleting product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products List'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.menu_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                cursorHeight: 35,
                decoration: InputDecoration(
                  hintText: 'Search for a product',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.grey[100],
                    child: Container(
                      width: double.infinity,
                      height: 250.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/hair.png'),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              color: Colors.white.withOpacity(0.8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    records[index]['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    'List Price: ${records[index]['list_price']}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_userType == UserType.Manager)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => editProduct(records[index]['id']),
                              ),
                            ),
                          if (_userType == UserType.Manager)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => performDelete(records[index]['id']),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: _userType == UserType.Manager
          ? FloatingActionButton(
              onPressed: navigateToAddProductForm,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
