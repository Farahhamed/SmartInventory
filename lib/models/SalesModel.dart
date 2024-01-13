import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/ProductModel.dart';

class Sales {
  final String date;
  final Product productId;
  final String quantity;
  final String uuid; // Add UUID property

  const Sales({
    required this.date,
    required this.productId,
    required this.quantity,
    required this.uuid,
  });

  // Function to convert Sales object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "date": date,
        "productId":
            productId.toMap(), // Convert Product to a map for Firestore
        "quantity": quantity,
        "uuid": uuid,
      };

  // Function to create a Sales object from a Firestore document
  static Sales fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Sales(
      date: data['date'],
      productId: Product.fromSnapshot(data['productId']),
      quantity: data['quantity'],
      uuid: data['uuid'],
    );
  }
}
