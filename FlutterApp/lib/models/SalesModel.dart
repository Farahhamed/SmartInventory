import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/ProductModel.dart'; // Import the Product model

class Discount {
  late String id;
  // final String name;
  // final String price;
  final String afterprice;
  final String percentage;
  // late String imageUrl;
  final DateTime discountExpire;
  final String productid;

  Discount(
      {required this.id,
      // required this.name,
      // required this.price,
      required this.afterprice,
      required this.percentage,
      // required this.imageUrl,
      required this.discountExpire,
      required this.productid});

  Map<String, dynamic> toMap() => {
        "uid": id,
        // "name": name,
        // "price": price,
        "afterprice": afterprice,
        "percentage": percentage,
        // "imageUrl": imageUrl,
        "discountExpire": discountExpire,
        "productid": productid
      };

  static Discount fromSnapshot(DocumentSnapshot snapshot) {
    // Use product properties to initialize Discount fields
    return Discount(
      id: snapshot.id,
      // name: product.name,
      // price: product.price,
      afterprice: snapshot['afterprice'],
      percentage: snapshot['percentage'],
      // imageUrl: product.imageUrl,
      discountExpire: snapshot['discountExpire'] != null
          ? (snapshot['discountExpire'] as Timestamp).toDate()
          : DateTime.now(),
      productid: snapshot['productid'],
    );
  }
}
