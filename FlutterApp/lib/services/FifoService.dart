import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class FifoService {

Future<List<Map<String, dynamic>>> fetchRealtimeDatabaseDataForProduct(String productId) async {
  try {
    final url = Uri.https('smartinventory-51751-default-rtdb.firebaseio.com', 'InventoryAccess.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> fifoList = [];

      print('Data retrieved from the database: $data');

      // Fetch product data and datetime from the database
      print('Searching for product with productId: $productId');
      
      bool foundProduct = false;
      
      try {
        data.entries.forEach((entry) {
          if (entry.value is Map<String, dynamic> && entry.value.containsKey('Data')) {
            Map<String, dynamic> productData = jsonDecode(entry.value['Data']);
            if (productData != null && productData is Map<String, dynamic> && productData['taguid'] == productId) {
              productData['datetime'] = productData['datetime']; // Assuming datetime is stored as key
              fifoList.add(productData);
              foundProduct = true;
              print('Retrieved product data: $productData');
            }
          }
        });
      } catch (e) {
        print('Error during iteration: $e');
      }

      if (!foundProduct) {
        print('Product with productId: $productId not found in the database.');
      }

      // Sort the fifoList by date
      fifoList.sort((a, b) {
        DateTime dateTimeA = DateTime.parse(a['datetime']);
        DateTime dateTimeB = DateTime.parse(b['datetime']);
        return dateTimeA.compareTo(dateTimeB);
      });

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

//   Future<List<Map<String, dynamic>>> fetchRealtimeDatabaseDataForProduct(String productId) async {
//   try {
//     final url = Uri.https('smartinventory-51751-default-rtdb.firebaseio.com', 'InventoryAccess.json');
//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = jsonDecode(response.body);

//       // Filter FIFO data for the provided product ID and cast to the correct type
//       List<Map<String, dynamic>> fifoList = data.entries
//           .where((entry) => entry.value['taguid'] == productId)
//           .map<Map<String, dynamic>>((entry) => entry.value as Map<String, dynamic>)
//           .toList();

//       return fifoList;
//     } else {
//       // Handle HTTP error
//       throw Exception('Failed to fetch data from the server');
//     }
//   } catch (e) {
//     // Handle other errors
//     print('Error fetching FIFO data: $e');
//     throw Exception('Failed to fetch FIFO data');
//   }
// }

}
