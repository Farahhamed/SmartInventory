import 'dart:convert';

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
                    MaterialPageRoute(builder: (context) => HomePageScreen()),
                  ); // Navigate back to the previous screen
                },
              ),
            ),
            body: ListView.builder(
              // reverse: true,
              // return ListView.builder(
              shrinkWrap: true,
              itemCount: LogsData.length,
              itemBuilder: (context, index) {
                Color dotColor = LogsData[index].value['Entry/Exit'] == 'Entry'
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
                              '${DateTime.parse(LogsData[index].value['datetime']).day}',
                              // 'Date is here',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                        LogsData[index].value['datetime'])),
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
                                      borderRadius: BorderRadius.circular(20.0),
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
  Map<String, dynamic> data = jsonDecode(response.body);

  List<MapEntry<String, dynamic>> TagsReadings = data.entries.toList();
  TagsReadings.sort((a, b) {
    DateTime dateTimeA = DateTime.parse(a.value['datetime']);
    DateTime dateTimeB = DateTime.parse(b.value['datetime']);
    return dateTimeA.compareTo(dateTimeB);
  });
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

Future<List<MapEntry<String, dynamic>>> masterFunction() async {
  List<MapEntry<String, dynamic>> TagsReadings =
      await fetchRealtimeDatabaseData();

  for (var i = 0; i < TagsReadings.length; i++) {
    // TagsReadings[i].value['Entry/Exit'] = "NA";
    // print(TagsReadings[i].value['datetime']);
    // print(TagsReadings[i].value['taguid']);
    // print(TagsReadings[i].value['Type']);
    // print(TagsReadings[i].value['Entry/Exit']);
    // TagsReadings[i].value['E/P:Name']

    String fetchedName = await getEmployeeName(
        TagsReadings[i].value['taguid'],
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
      // print("exit ${selectedUser['name']}   $dateTime");
    } else {
      EmployeesList.add((TagsReadings[i].value['taguid']));
      TagsReadings[i].value['Entry/Exit'] = "Entry";
      // print("enter ${selectedUser['name']}");
    }
  }
  return TagsReadings;
}
