import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinventory/models/EmployeeModel.dart';
import 'package:smartinventory/models/ProductModel.dart';

class StockChangeLogs {
  final String date;
  final String time;
  final Product productId;
  final Employee employeeId;

  StockChangeLogs({
    required this.date,
    required this.time,
    required this.productId,
    required this.employeeId,
  });

  // Function to convert StockChangeLogs object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "date": date,
        "time": time,
        "productId": {
          "name": productId.name,
          // Add other product properties as needed
        },
        "employeeId": {
          "name": employeeId.name,
          "position": employeeId.position,
          // Add other employee properties as needed
        },
      };

  // Save StockChangeLogs data to Firestore
  Future<void> saveToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('stockChangeLogs')
          .add(toMap());
    } catch (e) {
      print("Error saving to Firestore: $e");
      // Handle error as needed
    }
  }

  // Function to create a StockChangeLogs object from a Firestore document
  static StockChangeLogs fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return StockChangeLogs(
      date: data['date'],
      time: data['time'],
      productId: Product(
        name: data['productId']['name'],
        volume: data['productId']['volume'],
        weight: data['productId']['weight'],
        active: data['productId']['active'],
        imageUrl: data['productId']['imageUrl'],
        uuid: data['productId']['uuid'],
      ),
      employeeId: Employee(
        name: data['employeeId']['name'],
        position: data['employeeId']['position'],
      ),
    );
  }

  // Retrieve StockChangeLogs data from Firestore
  static Future<StockChangeLogs> getFromFirestore(String documentId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('stockChangeLogs')
          .doc(documentId)
          .get();
      return fromSnapshot(snapshot);
    } catch (e) {
      print("Error getting from Firestore: $e");
      // Handle error as needed
      throw Exception("Error getting StockChangeLogs from Firestore");
    }
  }
}
