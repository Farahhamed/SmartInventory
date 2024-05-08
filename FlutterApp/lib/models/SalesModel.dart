import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/ProductModel.dart'; // Import the Product model

class Discount {
  final String name;
  final String price;
  final String afterprice;
  final String percentage;
  late String imageUrl;
  late String id;
  final DateTime discountExpire;

  Discount({
    required this.name,
    required this.price,
    required this.afterprice,
    required this.percentage,
    required this.imageUrl,
    required this.id,
    required this.discountExpire,
  });

  Map<String, dynamic> toMap() => {
        "name": name,
        "price": price,
        "afterprice": afterprice,
        "percentage": percentage,
        "imageUrl": imageUrl,
        "uid": id,
        "discountExpire": discountExpire,
      };

  static Discount fromSnapshot(DocumentSnapshot snapshot, Product product) {
    // Use product properties to initialize Discount fields
    return Discount(
      name: product.name,
      price: product.price,
      afterprice: snapshot['afterprice'],
      percentage: snapshot['percentage'],
      imageUrl: product.imageUrl,
      id: snapshot.id,
      discountExpire: snapshot['discountExpire'] != null
          ? (snapshot['discountExpire'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
