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
    product.imageUrl = pic ;
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
    return _productsCollection.orderBy(
    'orderDateTime', 
    descending: sortOrder == 'LIFO'
  ).snapshots().asyncMap((snapshot) async {
    List<Product> products = [];
    for (DocumentSnapshot doc in snapshot.docs) {
      Product product = await Product.fromSnapshot(doc);
      products.add(product);
    }
    return products;
  });
  }
}
