import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Branches {
  final String name;
  final String location;
  String uuid; // Add UUID property

  // Constructor with UUID generation
  Branches({
    required this.location,
    required this.name,
  }) : uuid = Uuid().v4(); // Generate UUID during instantiation

  // Function to convert Branches object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "location": location,
        "uuid": uuid,
      };

  // Function to create a Branches object from a Firestore document
  static Branches fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Branches(
      name: data['name'],
      location: data['location'],
    )..uuid =
        data['uuid']; // Set UUID when creating the object from Firestore data
  }
}
