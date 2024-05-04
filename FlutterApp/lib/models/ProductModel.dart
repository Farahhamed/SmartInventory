import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/Product_categoryModel.dart';

class Product {
  final String name;
  final int quantity;
  final String description;
  final String price;
  final String categoryId; // Store the ID of the category instead of the object
  late String imageUrl;
  late String id;
  final DateTime orderDateTime;

  Product({
    required this.name,
    required this.quantity,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    required this.id,
    required this.orderDateTime, // Initialize this field
  });

  Map<String, dynamic> toMap() => {
        "name": name,
        "quantity": quantity,
        "description": description,
        "price": price,
        "categoryId": categoryId, // Store the ID
        "imageUrl": imageUrl,
        "uid": id,
        "orderDateTime": orderDateTime, // Add the orderDateTime to the map
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
      categoryId: data['categoryId'], // Get the ID
      orderDateTime: data['orderDateTime'] != null
          ? (data['orderDateTime'] as Timestamp).toDate() // Convert Timestamp to DateTime
          : DateTime.now(), // Default to current time if orderDateTime is missing
    );
}
}