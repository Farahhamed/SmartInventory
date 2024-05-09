import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smartinventory/screens/Homepage.dart';
import 'package:smartinventory/screens/NavigationBarScreen.dart';

late List<String> EmployeesList = [];

class LogsWidgetScreen extends StatefulWidget {
  const LogsWidgetScreen({super.key});

  @override
  State<LogsWidgetScreen> createState() => _LogsWidgetScreenState();
}

class _LogsWidgetScreenState extends State<LogsWidgetScreen> {
  late List<MapEntry<String, dynamic>> LogsData;
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    isLoaded = false;
    loadData();
  }

  Future<void> refreshData() async {
    setState(() {
      isLoaded = false;
      EmployeesList = [];
    });
    loadData();
  }

  void loadData() async {
    List<MapEntry<String, dynamic>> data = await masterFunction();
    setState(() {
      LogsData = data;
      // print("lolo $LogsData");
      LogsData = LogsData.reversed.toList();
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? const Center(
            child:
                CircularProgressIndicator(), // if isLoading is true, show loading in ui
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Access Log'),
              backgroundColor: Colors
                  .grey[200], // Set background color to a light grey shade
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  ); // Navigate back to the previous screen
                },
              ),
            ),
            body: RefreshIndicator(
              onRefresh: refreshData,
              child: ListView.builder(
                // reverse: true,
                // return ListView.builder(
                shrinkWrap: true,
                itemCount: LogsData.length,
                itemBuilder: (context, index) {
                  Color dotColor =
                      LogsData[index].value['Entry/Exit'] == 'Entry'
                          ? Colors.orange
                          : Colors.red;
                  // EmployeeOrProductName = selectedUser['name'];
                  // RFIDTagUid = selectedUser['Tag'];

                  // print('snapchot is: ${EmployeesList}  $dateTime');
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline on the left
                        SizedBox(
                          width: 50.0,
                          child: Column(
                            children: [
                              Text(
                                '${DateTime.parse(LogsData[index].value['datetime'] == "" ? "" : LogsData[index].value['datetime']).day}',
                                // 'Date is here',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(DateFormat.MMM().format(DateTime.parse(
                                  LogsData[index].value['datetime']))),
                              const SizedBox(height: 5.0),
                              Container(
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dotColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        // Vertical line
                        Container(
                          width: 2.0,
                          height: 50.0, // Adjust height according to your UI
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10.0),
                        // Card-like shape on the right
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Activity type
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    // 'activity type is here',
                                    LogsData[index].value['Entry/Exit'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                // Time
                                Row(
                                  children: [
                                    const Icon(Icons.access_time),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      DateFormat.Hms().format(DateTime.parse(
                                          LogsData[index].value['datetime'] ==
                                                  ""
                                              ? ""
                                              : LogsData[index]
                                                  .value['datetime'])),
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                // Category and RFID details
                                Row(
                                  children: [
                                    const Icon(Icons.category),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      LogsData[index].value['Type'],
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.confirmation_number),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      LogsData[index].value['taguid'],
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                // Employee details
                                Row(
                                  children: [
                                    Icon(LogsData[index].value['Type'] ==
                                            "Employee"
                                        ? Icons.person
                                        : Icons.category),
                                    const SizedBox(width: 5.0),
                                    Text(LogsData[index].value['E/P:Name']),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Text(
                                        'Tag ID',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ));
  }
}

Future<List<MapEntry<String, dynamic>>> fetchRealtimeDatabaseData() async {
  final url = Uri.https('smartinventory-51751-default-rtdb.firebaseio.com',
      'InventoryAccess.json');
  var response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );
  // Map<String, dynamic> data = jsonDecode(response.body);

  Map<String, dynamic> data = jsonDecode(response.body);

  List<MapEntry<String, dynamic>> TagsReadings = data.entries.map((entry) {
    return MapEntry(entry.key, jsonDecode(entry.value['Data'].toString()));
  }).toList();

  print("yarab: ${TagsReadings[0].value['taguid']}");

  // print("shakl awel data 5ales $data");
  // List<MapEntry<String, dynamic>> TagsReadings = data.entries.toList();
  // print("shakl el data: $TagsReadings");
  // print("shakl item wa7ed: ${TagsReadings[0].value}");
  TagsReadings.sort((a, b) {
    DateTime dateTimeA = DateTime.parse(a.value['datetime'] as String);
    DateTime dateTimeB = DateTime.parse(b.value['datetime'] as String);
    return dateTimeA.compareTo(dateTimeB);
  });
  // print("hellz");
  return TagsReadings;
  // }
}

Future<String> GetProductName(String ProductId) async {
  // Reference to the Firestore collection
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('Products')
      .where('uid', isEqualTo: ProductId)
      .get();

  if (snapshot.docs.isNotEmpty) {
    // print("EmployeeName is: ${snapshot.docs[0]['name']}");
    return snapshot.docs[0]['name'];
  }
  return "";
}

Future<String> getEmployeeName(String TagUid, String collectionName) async {
  try {
    // print(collectionName);
    QuerySnapshot<Map<String, dynamic>> snapshot =
        collectionName == 'Register_employees'
            ? await FirebaseFirestore.instance
                .collection(collectionName)
                .where('Tag', isEqualTo: TagUid)
                .get()
            : await FirebaseFirestore.instance
                .collection(collectionName)
                .where('UID', isEqualTo: TagUid)
                .get();

    // print("hoho ${snapshot.docs[0]['name']}");
    if (snapshot.docs.isNotEmpty) {
      // print("EmployeeName is: ${snapshot.docs[0]['name']}");

      return collectionName == "Register_employees"
          ? snapshot.docs[0]['name']
          : GetProductName(snapshot.docs[0]['ProductId']);
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  return "";
}

String RemoveZerosFromStart(String taguid) {
  String FinalResult = "";

  for (int i = 0; i < taguid.length; i++) {
    if (i % 3 == 0) {
      if (taguid[i] == '0') {
        continue;
      }
    }
    FinalResult += taguid[i];
  }
  return FinalResult;
}

Future<List<MapEntry<String, dynamic>>> masterFunction() async {
  List<MapEntry<String, dynamic>> TagsReadings =
      await fetchRealtimeDatabaseData();
  print("new fetched data: $TagsReadings");

  for (var i = 0; i < TagsReadings.length; i++) {
    // TagsReadings[i].value['Entry/Exit'] = "NA";
    // print(TagsReadings[i].value['datetime']);
    // print(TagsReadings[i].value['taguid']);
    // print(TagsReadings[i].value['Type']);
    // print(TagsReadings[i].value['Entry/Exit']);
    // TagsReadings[i].value['E/P:Name']

    String fetchedName = await getEmployeeName(
        RemoveZerosFromStart(TagsReadings[i].value['taguid']),
        TagsReadings[i].value['Type'] == "Employee"
            ? 'Register_employees'
            : 'Assigned_Products');
    if (fetchedName != "") {
      TagsReadings[i].value['E/P:Name'] = fetchedName;
    } else {
      TagsReadings[i].value['E/P:Name'] = "Error fetching Name";
    }

    if (EmployeesList.contains(TagsReadings[i].value['taguid'])) {
      EmployeesList.remove(TagsReadings[i].value['taguid']);
      TagsReadings[i].value['Entry/Exit'] = "Exit";
    } else {
      EmployeesList.add((TagsReadings[i].value['taguid']));
      TagsReadings[i].value['Entry/Exit'] = "Entry";
    }

    if (TagsReadings[i].value['IsChecked'] == false &&
        TagsReadings[i].value['Type'] != "Employee") {
      await ChangeQuantity(TagsReadings[i]);
    }
  }
  return TagsReadings;
}

Future<void> ChangeQuantity(MapEntry<String, dynamic> Product) async {
  QuerySnapshot<Map<String, dynamic>> snapshot1 = await FirebaseFirestore
      .instance
      .collection("Assigned_Products")
      .where('UID', isEqualTo: RemoveZerosFromStart(Product.value['taguid']))
      .get();

  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('Products')
      .where('uid', isEqualTo: snapshot1.docs[0]['ProductId'])
      .get();

  if (snapshot.docs.isNotEmpty) {
    // print("EmployeeName is: ${snapshot.docs[0]['name']}");
    // print("product price is  ${snapshot.docs[0]['price']}");
    int currentquantity = snapshot.docs[0]['quantity'];
    if (Product.value['Entry/Exit'] == "Entry") {
      currentquantity = currentquantity + 1;
    } else {
      currentquantity = currentquantity - 1;
    }

    await FirebaseFirestore.instance
        .collection('Products')
        .doc(snapshot.docs[0]['uid'])
        .update({'quantity': currentquantity});

    await UpdateRealTimeDB(Product);
  }
}

Future<void> UpdateRealTimeDB(MapEntry<String, dynamic> product) async {
  String jsonPayloadBefore = "{";
  jsonPayloadBefore += "\"datetime\":\"" + product.value['datetime'] + "\",";
  jsonPayloadBefore += "\"taguid\":\"" + product.value['taguid'] + "\",";
  jsonPayloadBefore += "\"Type\":\"" + product.value['Type'] + "\",";
  jsonPayloadBefore += "\"IsChecked\":false,";
  jsonPayloadBefore += "\"uniqueID\":\"" + product.value['uniqueID'] + "\"";
  jsonPayloadBefore += "}";

  String jsonPayloadAfter = "{";
  jsonPayloadAfter += "\"datetime\":\"" + product.value['datetime'] + "\",";
  jsonPayloadAfter += "\"taguid\":\"" + product.value['taguid'] + "\",";
  jsonPayloadAfter += "\"Type\":\"" + product.value['Type'] + "\",";
  jsonPayloadAfter += "\"IsChecked\":true,";
  jsonPayloadAfter += "\"uniqueID\":\"" + product.value['uniqueID'] + "\"";
  jsonPayloadAfter += "}";

  DatabaseReference refUpdate = FirebaseDatabase.instance
      .ref("InventoryAccess/${product.value['uniqueID']}/Data");

  await refUpdate.set(jsonPayloadAfter);

  // DatabaseReference refAdd =
  //     FirebaseDatabase.instance.ref("InventoryAccess/${jsonPayloadAfter}");

  // await refAdd.remove();
}
