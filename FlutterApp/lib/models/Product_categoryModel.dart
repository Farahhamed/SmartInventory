import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductCategory {
  final String name;
  String uuid; // Remove final from uuid

  // Constructor with UUID generation
  ProductCategory({
    required this.name,
  }) : uuid = const Uuid().v4(); // Generate UUID during instantiation

  // Function to convert ProductCategory object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "uuid": uuid,
      };

  // Function to create a ProductCategory object from a Firestore document
  static ProductCategory fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return ProductCategory(
      name: data['name'],
    )..uuid =
        data['uuid']; // Set UUID when creating the object from Firestore data
  }
}
