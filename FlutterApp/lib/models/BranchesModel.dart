import 'package:cloud_firestore/cloud_firestore.dart';


class Branches {
  final String name;
  final String location;
  final String id;

  Branches({
    required this.location,
    required this.name,
    required this.id,
  });

  // Function to convert Branches object to a Map for Firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "location": location,
        "id": id,
      };

  // Function to create a Branches object from a Firestore document
  static Branches fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Branches(
      name: data['name'],
      location: data['location'],
      id: snapshot.id
    ); 
  }
}
