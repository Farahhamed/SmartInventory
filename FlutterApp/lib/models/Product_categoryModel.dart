import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductCategory {
  final String name;
  final String id; 

  ProductCategory({required this.name, required this.id});

  // Function to convert ProductCategory object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
      };

  // Function to create a ProductCategory object from a Firestore document
  static ProductCategory fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return ProductCategory(
      name: data['name'],
      id: data["id"],
    );
  }
}
