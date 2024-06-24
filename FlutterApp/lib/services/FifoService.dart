import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartinventory/screens/AccessMonitoring.dart';

class NoEntryDataException implements Exception {
  final String message;
  NoEntryDataException(this.message);
}

class ProductNotFoundException implements Exception {
  final String message;
  ProductNotFoundException(this.message);
}

class FifoService {
  Future<Map<String, dynamic>> fetchRealtimeDatabaseDataForProduct() async {
    // Fetching current state of products
    List<MapEntry<String, dynamic>> productStates = await masterFunction();
    print(productStates);
    Map<String, dynamic> fifolist = {};
    List<String> exitUid = [];
    for (var product in productStates) {
      if (product.value["Type"] == "Product") {
        if (product.value["Entry/Exit"] == "Entry") {
          fifolist[product.value["taguid"]] = product.value["datetime"];
        } else {
          exitUid.add(product.value["taguid"]);
        }
      }
      for(var uid in exitUid){
        if(fifolist.containsKey(uid)){
          fifolist.remove(uid);
        }
      }
    }
    return fifolist;
    //   try {
    //     final url = Uri.https('smartinventory-51751-default-rtdb.firebaseio.com',
    //         'InventoryAccess.json');
    //     var response = await http.get(url);

    //     if (response.statusCode == 200) {
    //       Map<String, dynamic> data = jsonDecode(response.body);
    //       List<Map<String, dynamic>> fifoList = [];
    //       List<Map<String, dynamic>> exitedProducts = [];

    //       // Fetching current state of products
    //       List<MapEntry<String, dynamic>> productStates = await masterFunction();
    //       print(productStates);

    //       for (String uid in uids) {
    //         bool foundProduct = false;
    //         bool isEntry = false;
    //         bool isExit = false;
    //         try {
    //           data.entries.forEach((entry) {
    //             if (entry.value is Map<String, dynamic> &&
    //                 entry.value.containsKey('Data')) {
    //               Map<String, dynamic> productData =
    //                   jsonDecode(entry.value['Data']);
    //               if (productData != null && productData['taguid'] == uid && productData.containsKey('datetime')) {
    //                 // Check if the entry represents an "Entry" rather than an "Exit"
    //                 isExit = productStates.any((state) =>
    //                     state.value['taguid'] == uid &&
    //                     state.value['Entry/Exit'] == 'Exit');
    //                 if (isExit) {
    //                   exitedProducts.add(productData);
    //                 }
    //                 isEntry = productStates.any((state) =>
    //                     state.value['taguid'] == uid &&
    //                     state.value['Entry/Exit'] == 'Entry');
    //                 if (isEntry) {
    //                   fifoList.add(productData);
    //                   foundProduct = true;
    //                 }
    //                 if(fifoList.last == exitedProducts.last)
    //                 {
    //                   fifoList.remove(productData);
    //                 }
    //               }
    //             }
    //           });
    //         } catch (e) {
    //           print('Error during iteration: $e');
    //         }

    //         if (!foundProduct) {
    //           print('Product with UID: $uid not found in the database.');
    //         }
    //       }

    //       /// Sort the fifoList by date
    //       fifoList.sort((a, b) {
    //         DateTime dateTimeA = DateTime.parse(a['datetime']);
    //         DateTime dateTimeB = DateTime.parse(b['datetime']);
    //         return dateTimeA.compareTo(dateTimeB);
    //       });

    //       return fifoList;
    //     } else {
    //       throw Exception(
    //           'Failed to fetch data from the server: ${response.statusCode}');
    //     }
    //   } catch (e) {
    //     print('Error fetching FIFO data: $e');
    //     throw Exception('Failed to fetch FIFO data: $e');
    //   }
  }
}
