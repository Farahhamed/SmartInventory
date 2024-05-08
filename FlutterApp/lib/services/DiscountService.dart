import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartinventory/models/SalesModel.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/services/ProductsService.dart';
import 'package:uuid/uuid.dart';

class DiscountService {
  final CollectionReference _discountsCollection =
      FirebaseFirestore.instance.collection('Discounts');
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('Products');
  final ProductService _productservice = new ProductService();

  Future<bool> applyDiscount(Product product, double discountRate) async {
    try {
      // Calculate discounted price

      double originalPrice = double.parse(product.price);
      double discountedPrice =
          originalPrice - (originalPrice * (discountRate / 100));

      // QuerySnapshot querySnapshot = await _productsCollection
      //     .where('name', isEqualTo: product.name)
      //     .limit(1)
      //     .get();
      // if (querySnapshot.docs.isNotEmpty) {
      //   print('Discount with name ${product.name} already exists');
      //   return false; // Discount already exists
      // }
      // Create Discount object
      Discount discount = Discount(
          // name: product.name,
          // price: product.price.toString(),
          afterprice: discountedPrice.toString(),
          percentage: discountRate.toString(),
          // imageUrl: product.imageUrl,
          id: Uuid().v4(), // Generate unique ID
          discountExpire: DateTime.now(),
          productid: product.id);

      // Save discount to Firestore
      await _discountsCollection.doc(discount.id).set(discount.toMap());

      return true; // Discount applied successfully
    } catch (e) {
      print('Error applying discount: $e');
      return false; // Failed to apply discount
    }
  }

  // Function to edit a discount
  Future<void> editDiscount(String discountId, Discount updatedDiscount) async {
    try {
      await _discountsCollection
          .doc(discountId)
          .update(updatedDiscount.toMap());
    } catch (e) {
      print('Error editing discount: $e');
      throw e; // Rethrow the error
    }
  }

  // Function to delete a discount
  Future<void> deleteDiscount(String discountId) async {
    try {
      await _discountsCollection.doc(discountId).delete();
    } catch (e) {
      print('Error deleting discount: $e');
      throw e; // Rethrow the error
    }
  }

  Future<List<MapEntry<String, dynamic>>?> getDiscount() async {
    List<MapEntry<String, dynamic>> finalData = [];
    await for (QuerySnapshot snapshot in _discountsCollection.snapshots()) {
      // int i = 0;
      for (DocumentSnapshot doc in snapshot.docs) {
        MapEntry<String, dynamic> product;

        product = MapEntry<String, dynamic>('data', doc.data());
        // product = jsonDecode(doc.data().toString());
        // print("hell from a product: $product");

        Product productitem =
            await _productservice.getProductById(product.value['productid']);
        product.value['name'] = productitem.name;
        product.value['price'] = productitem.price;
        product.value['imageUrl'] = productitem.imageUrl;
        finalData.add(product);
        // discounts.add(discount); // Add each discount to the list
        // i = i + 1;
      }
      return finalData;
    }
    return null;
  }
}
