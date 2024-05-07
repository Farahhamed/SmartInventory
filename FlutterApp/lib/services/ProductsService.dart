import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smartinventory/models/ProductModel.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference _assignedProductsCollection =
      FirebaseFirestore.instance.collection('Assigned_Products');

  Future<bool> addProduct(Product product, File file) async {
    var uuid = Uuid().v4();
    // Check if the product already exists
    QuerySnapshot querySnapshot = await _productsCollection
        .where('name', isEqualTo: product.name)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print('Product with name ${product.name} already exists');
      return false; // Product already exists
    }
    product.id = uuid;
    // Product doesn't exist, so add it
    String pic;
    final ref =
        FirebaseStorage.instance.ref().child('ProductPictures/$uuid/pic');
    await ref.putFile(file!);
    pic = await ref.getDownloadURL();
    product.imageUrl = pic;
    await _productsCollection.doc(uuid).set(product.toMap());

    return true; // Product added successfully
  }

  Future<void> editProduct(Product product) async {
    // Check if the product already exists
    QuerySnapshot querySnapshot = await _productsCollection
        .where('name', isEqualTo: product.name)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print('Product with  ${product.name} does not exist');
      return;
    }

    // Product exists, so edit it
    await _productsCollection.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _productsCollection.doc(productId).delete();
  }

  Stream<List<Product>> getProduct() {
    return _productsCollection.snapshots().asyncMap((snapshot) async {
      List<Product> products = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Product product = await Product.fromSnapshot(doc);
        products.add(product);
      }
      return products;
    });
  }

  Stream<List<Product>> getProductsOrder({String? sortOrder}) {
    return _productsCollection
        .orderBy('orderDateTime', descending: sortOrder == 'LIFO')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Product> products = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Product product = await Product.fromSnapshot(doc);
        products.add(product);
      }
      return products;
    });
  }

  Future<List<String>> getAssignedProductIds() async {
    List<String> assignedProductIds = [];

    try {
      // Fetch all assigned product IDs from Assigned_Products collection
      QuerySnapshot assignedProductsSnapshot = await FirebaseFirestore.instance
          .collection('Assigned_Products')
          .get();

      // Extract product IDs
      assignedProductsSnapshot.docs.forEach((doc) {
        assignedProductIds.add(doc['ProductId']);
      });

      return assignedProductIds;
    } catch (e) {
      print("Error getting assigned product IDs: $e");
      return assignedProductIds;
    }
  }

  Future<Product> getProductById(String productId) async {
    try {
      // Fetch product with the given ID from Products collection
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .get();

      // Check if product exists
      if (productSnapshot.exists) {
        // Convert snapshot data to Product object
        Product product = Product.fromSnapshot(productSnapshot);
        return product;
      } else {
        // Throw an error if product doesn't exist
        throw Exception("Product with ID $productId does not exist");
      }
    } catch (e) {
      // Throw an error if any other error occurs
      throw Exception("Error getting product by ID: $e");
    }
  }

// Future<List<Product>> getProductsFromAssignedProducts() async {
//   List<Product> products = [];

//   QuerySnapshot<Map<String, dynamic>> assignedProductsSnapshot =
//       await _assignedProductsCollection.get() as QuerySnapshot<Map<String, dynamic>>;

//   for (QueryDocumentSnapshot<Map<String, dynamic>> assignedProductDoc
//       in assignedProductsSnapshot.docs) {
//     String productId = assignedProductDoc['ProductId'];
//     DocumentSnapshot<Map<String, dynamic>> productSnapshot =
//         await _productsCollection.doc(productId).get() as DocumentSnapshot<Map<String, dynamic>>;

//     if (productSnapshot.exists) {
//       Product product = Product(
//         name: productSnapshot['name'],
//         quantity: productSnapshot['quantity'],
//         description: productSnapshot['description'],
//         price: productSnapshot['price'],
//         categoryId: productSnapshot['categoryId'],
//         imageUrl: productSnapshot['imageUrl'],
//         id: productSnapshot.id,
//         orderDateTime: DateTime.parse(
//             productSnapshot['orderDateTime'].toString()), // Assuming orderDateTime is stored as a String
//       );
//       products.add(product);
//     }
//   }

//   return products;
// }
}
