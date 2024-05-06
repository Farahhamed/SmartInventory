import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/screens/AddProduct.dart';
import 'package:smartinventory/screens/AssignTagToProduct.dart';
import 'package:smartinventory/screens/OneProduct.dart';
import 'package:smartinventory/screens/SideBar.dart';
import 'package:smartinventory/services/ProductsService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/screens/EditProductScreen.dart';

enum UserType { Supervisor, Employee }

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final ProductService productService = ProductService();
  List<Product> products = [];
  UserType _userType = UserType.Employee;

  @override
  void initState() {
    super.initState();
    _getUserType();
    _fetchProducts();
  }

  Future<void> _getUserType() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Register_employees')
          .doc(currentUser.uid)
          .get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        dynamic userData = userSnapshot.data();
        String? userType = userData?['employeeType'] as String?;

        if (userType == 'Supervisor') {
          setState(() {
            _userType = UserType.Supervisor;
          });
        } else {
          setState(() {
            _userType = UserType.Employee;
          });
        }
      }
    }
  }

  Future<void> _fetchProducts() async {
    productService.getProduct().listen((List<Product> productList) {
      setState(() {
        products = productList;
      });
    });
  }

  void navigateToAddProductForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProduct(),
      ),
    );
  }

  void navigateToEditProductForm(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          product: product,
          updateProduct: _updateProduct,
        ),
      ),
    );
  }

  void _updateProduct(Product updatedProduct) async {
    try {
      await productService.editProduct(updatedProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update product: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> performDelete(String productId) async {
    await productService.deleteProduct(productId);
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Scaffold(
        key: scaffoldKey,
        drawer: NavBar(),
        appBar: AppBar(
          title: const Text('Products List'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.menu_sharp,
              color: Colors.black,
            ),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            if (_userType == UserType.Supervisor)
              Ink(
                decoration: const BoxDecoration(
                  color: Color(0xFFBB8493),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProduct()),
                    );
                  },
                  tooltip: 'Add Product',
                ),
              ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  Product product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                              product:
                                  product), // Pass the selected product to ProductDetails screen
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.grey[100],
                        child: Container(
                          height: 250.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(product.imageUrl),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        'Price: ${product.price}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      Text(
                                        'Quantity: ${product.quantity}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_userType == UserType.Supervisor)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        navigateToEditProductForm(product),
                                  ),
                                ),
                              if (_userType == UserType.Supervisor)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => performDelete(product.id),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
