import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final int quantity;
  final String description;
  final String price;
  final String categoryId; // Store the ID of the category instead of the object
  late String imageUrl;
  late String id;
  final DateTime orderDateTime;
  late bool discountApplied;

  Product({
    required this.name,
    required this.quantity,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    required this.id,
    required this.orderDateTime, // Initialize this field
    required this.discountApplied,
  });

  Map<String, dynamic> toMap() => {
        "name": name,
        "quantity": quantity,
        "description": description,
        "price": price,
        "categoryId": categoryId, // Store the ID
        "imageUrl": imageUrl,
        "uid": id,
        "orderDateTime": orderDateTime,
      };

  static Product fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Product(
      name: data['name'],
      quantity: data['quantity'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
      id: snapshot.id,
      categoryId: data['categoryId'],
      orderDateTime: data['orderDateTime'] != null
          ? (data['orderDateTime'] as Timestamp).toDate()
          : DateTime.now(),
      discountApplied: data['discountApplied'] ??
          false, // Fetch discountApplied from Firestore data
    );
  }
}
