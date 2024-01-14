import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String volume;
  final String weight;
  final String active;
  final String imageUrl;
  final String uuid;

  const Product({
    required this.name,
    required this.volume,
    required this.weight,
    required this.active,
    required this.imageUrl,
    required this.uuid,
  });

  // Function to convert Product object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "volume": volume,
        "weight": weight,
        "active": active,
        "imageUrl": imageUrl, // Store image URL in Firestore
        "uuid": uuid,
      };

  // Function to create a Product object from a Firestore document
  static Product fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Product(
      name: data['name'],
      volume: data['volume'],
      weight: data['weight'],
      active: data['active'],
      imageUrl: data['imageUrl'],
      uuid: data['uuid'],
    );
  }
}
