import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartinventory/models/SalesModel.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:uuid/uuid.dart';

class DiscountService {
  final CollectionReference _discountsCollection =
      FirebaseFirestore.instance.collection('Discounts');
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('Products');

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
        name: product.name,
        price: product.price.toString(),
        afterprice: discountedPrice.toString(),
        percentage: discountRate.toString(),
        imageUrl: product.imageUrl,
        id: Uuid().v4(), // Generate unique ID
        discountExpire: DateTime.now(),
      );

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

  // Stream<List<Discount>> getDiscount() async* {
  //   await for (QuerySnapshot snapshot in _discountsCollection.snapshots()) {
  //     List<Discount> discounts = [];
  //     for (DocumentSnapshot doc in snapshot.docs) {
  //       Discount discount = Discount.fromSnapshot(doc);
  //       discounts.add(discount); // Add each discount to the list
  //     }
  //     yield discounts;
  //   }
  // }
}
