import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/Product_categoryModel.dart';

class Product {
  final String name;
  final int quantity;
  final String description;
  final String price;
  final ProductCategory categoryId;
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

  // Function to convert Product object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "quantity": quantity,
        "description": description,
        "price": price,
        "categoryId": categoryId,
        "imageUrl": imageUrl, // Store image URL in Firestore
        "uid": id,
      };

  // Function to create a Product object from a Firestore document
  static Future<Product> fromSnapshot(DocumentSnapshot snapshot) async {
  var data = snapshot.data() as Map<String, dynamic>;
  
  // Fetch the branch document from Firestore
  DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance.collection('category').doc(data['categoryId']).get();
  
  // Create a Branches object using data from the branch document
  ProductCategory category = ProductCategory.fromSnapshot(categorySnapshot);

    return Product(
      name: data['name'],
      quantity: data['quantity'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
      id: snapshot.id,
      categoryId: category,
    );
  }
}
