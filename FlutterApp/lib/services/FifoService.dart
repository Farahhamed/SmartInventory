import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class FifoService {
  // Future<void> updateFIFOList(
  //     String productId, String entryDate, String employeeName) async {
  //   DatabaseReference ref = FirebaseDatabase.instance
  //       .reference()
  //       .child('FIFO_Lists')
  //       .child(productId);

  //   // Push a new entry for the product with the entry date and employee name
  //   await ref.push().set({
  //     'date': entryDate,
  //     'employee_name': employeeName,
  //   });

  //   // Listen for changes in the FIFO list entries and keep track of the oldest entry
  //   ref.orderByChild('date').limitToFirst(10).onValue.listen((event) async {
  //     DataSnapshot snapshot = event.snapshot;

  //     // Check if snapshot value is not null before accessing the length property
  //     if (snapshot.value != null && (snapshot.value as Map).length > 10) {
  //       Map<dynamic, dynamic> entries = snapshot.value as Map;
  //       List<dynamic> keys = entries.keys.toList();
  //       String oldestKey = keys.first;
  //       await ref.child(oldestKey).remove();
  //     }
  //   });
  // }

Future<List<Map<String, dynamic>>> getFIFOListForProduct(String productId) async {
    // Query the FIFO data from the realtime database based on the product ID
    List<Map<String, dynamic>> fifoList = await fetchRealtimeDatabaseDataForProduct(productId);

    // Sort the FIFO list by entry date
    fifoList.sort((a, b) {
      DateTime dateTimeA = DateTime.parse(a['datetime']);
      DateTime dateTimeB = DateTime.parse(b['datetime']);
      return dateTimeA.compareTo(dateTimeB);
    });

    // Return the sorted FIFO list
    return fifoList;
  }

  Future<List<Map<String, dynamic>>> fetchRealtimeDatabaseDataForProduct(String productId) async {
  try {
    final url = Uri.https('smartinventory-51751-default-rtdb.firebaseio.com', 'InventoryAccess.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      // Filter FIFO data for the provided product ID and cast to the correct type
      List<Map<String, dynamic>> fifoList = data.entries
          .where((entry) => entry.value['taguid'] == productId)
          .map<Map<String, dynamic>>((entry) => entry.value as Map<String, dynamic>)
          .toList();

      return fifoList;
    } else {
      // Handle HTTP error
      throw Exception('Failed to fetch data from the server');
    }
  } catch (e) {
    // Handle other errors
    print('Error fetching FIFO data: $e');
    throw Exception('Failed to fetch FIFO data');
  }
}

  // Future<List<Map<String, dynamic>>> getFIFOListForProduct(String productId) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
  //         .collection('FIFOLists')
  //         .doc(productId)
  //         .collection('entries')
  //         .orderBy('date', descending: true)
  //         .get();

  //     List<Map<String, dynamic>> fifoList = snapshot.docs.map((doc) {
  //       return {
  //         'date': doc['date'], // Assuming date is stored in 'date' field
  //         'employee_name': doc['employee_name'], // Assuming employee name is stored in 'employee_name' field
  //         // Add other fields as needed
  //       };
  //     }).toList();

  //     return fifoList;
  //   } catch (e) {
  //     print('Error fetching FIFO list: $e');
  //     return []; // Return empty list if an error occurs
  //   }
  // }
}
