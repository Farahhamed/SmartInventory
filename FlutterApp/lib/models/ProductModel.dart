import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/Product_categoryModel.dart';

class Product {
  final String name;
  final int quantity;
  final String description;
  final double price;
  final String categoryId; // Store the ID of the category instead of the object
  final String imageUrl;
  final String id;

  const Product({
    required this.name,
    required this.quantity,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    required this.id,
  });

  Map<String, dynamic> toMap() => {
        "name": name,
        "quantity": quantity,
        "description": description,
        "price": price,
        "categoryId": categoryId, // Store the ID
        "imageUrl": imageUrl,
        "uid": id,
      };

  static Product fromSnapshot(DocumentSnapshot snapshot)  {
    var data = snapshot.data() as Map<String, dynamic>;
    return Product(
      name: data['name'],
      quantity: data['quantity'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
      id: snapshot.id,
      categoryId: data['categoryId'], // Get the ID
    );
  }
  
}
