import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smartinventory/screens/Notification.dart';
import 'package:smartinventory/screens/SideBar.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<MapEntry<String, dynamic>> LogsData;
  bool isLoaded = false;
  late double income;
  late double expenses;
  @override
  void initState() {
    super.initState();
    isLoaded = false;
    loadData();
  }

  void loadData() async {
    Map<String, dynamic> data = await masterFunction();
    print("Final data is: $data");
    setState(() {
      LogsData = data['tags'] as List<MapEntry<String, dynamic>>;
      income = data['income'] as double;
      expenses = data['expenses'] as double;
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
            key: scaffoldKey,
            drawer: NavBar(),
            body: Stack(
              children: [
                // Background image and content
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/blurHomePage.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white),
                              onPressed: () {
                                scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                          ),
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: IconButton(
                              icon: const Icon(Icons.notifications,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotificationPage()),
                                );
                              },
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: IconButton(
                          //     icon: const Icon(Icons.more_vert, color: Colors.white),
                          //     onPressed: () {
                          //       //
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 7.0),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Gross Profit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              '\$${income - expenses}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                              ),
                            ),
                            Text(
                              'Total balance',
                              style: TextStyle(
                                color: Color.fromRGBO(119, 176, 170, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 220.0,
                  left: 16.0,
                  right: 16.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // First Card
                        SizedBox(
                          height: 135.0,
                          width: 135.0,
                          child: Card(
                            elevation: 4,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Custom content for the first card
                                    Container(
                                      height: 32,
                                      width: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF9BBEC8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/pay.png",
                                          height: 28,
                                          width: 28,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Income',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${income}',
                                      style: TextStyle(
                                        color: Color(0xFF135D66),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'From Balance',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10.0),

                        // Second Card
                        SizedBox(
                          height: 135.0,
                          width: 135.0,
                          child: Card(
                            elevation: 4,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 32,
                                      width: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF9BBEC8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/balance.png",
                                          height: 28,
                                          width: 28,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Expenses',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${expenses}',
                                      style: TextStyle(
                                        color: Color(0xFF135D66),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Balance left',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 380.0,
                  left: 12.0,
                  right: 12.0,
                  bottom: 12.0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             const Text(
                                'Recent Transactions',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            // TextButton(
                            //   onPressed: () {},
                            //   child: const Text(
                            //     'View All',
                            //     style: TextStyle(
                            //       fontSize: 16,
                            //       color: Color(0xFFBB8493),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        // const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: LogsData.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.transparent,
                                      margin: const EdgeInsets.only(right: 16),
                                      child: Image.asset(
                                          "assets/images/pain killers.png"),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            LogsData[index].value['E/P:Name'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            LogsData[index].value['category'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '\$${LogsData[index].value['price']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          LogsData[index].value['Entry/Exit'],
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                119, 176, 170, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

late List<String> EmployeesList = [];

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

Future<Map<String, dynamic>> GetProductName(String TagUid) async {
  // print("tag is: $TagUid");
  QuerySnapshot<Map<String, dynamic>> snapshotp = await FirebaseFirestore
      .instance
      .collection("Assigned_Products")
      .where('UID', isEqualTo: TagUid)
      .get();

  String ProductId = snapshotp.docs[0]['ProductId'];
  // print("productid: $ProductId");

  // Reference to the Firestore collection
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('Products')
      .where('uid', isEqualTo: ProductId)
      .get();

  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('Categories')
      .doc(snapshot.docs[0]['categoryId'])
      .get();
  // .where('UID', isEqualTo: TagUid)
  // .get();

  if (snapshot.docs.isNotEmpty) {
    // print("product name: ${snapshot.docs[0]['name']}");

    return {
      'name': snapshot.docs[0]['name'],
      'price': snapshot.docs[0]['price'],
      'category': doc['name']
    };
  }
  return {
    'name': '',
    'price': '',
  };
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

Future<Map<String, dynamic>> masterFunction() async {
  List<MapEntry<String, dynamic>> TagsReadings =
      await fetchRealtimeDatabaseData();
  double income = 0.0;
  double expenses = 0.0;

  TagsReadings.removeWhere((entry) => entry.value['Type'] == 'Employee');
  // print("new fetched data: $TagsReadings");

  for (var i = 0; i < TagsReadings.length; i++) {
    // TagsReadings[i].value['Entry/Exit'] = "NA";
    // print(TagsReadings[i].value['datetime']);
    // print(TagsReadings[i].value['taguid']);
    // print(TagsReadings[i].value['Type']);
    // print(TagsReadings[i].value['Entry/Exit']);
    // TagsReadings[i].value['E/P:Name']

    // if (TagsReadings[i].value['Type'] == "Employee") {
    //   continue;
    // }
    Map<String, dynamic> productDetails = await GetProductName(
        RemoveZerosFromStart(TagsReadings[i].value['taguid']));

    if (productDetails['name'] != "") {
      TagsReadings[i].value['E/P:Name'] = productDetails['name'];
    } else {
      TagsReadings[i].value['E/P:Name'] = "Error fetching Name";
    }

    TagsReadings[i].value['category'] = productDetails['category'];

    double price = double.tryParse(productDetails['price'].toString()) ?? 0.0;

    if (EmployeesList.contains(TagsReadings[i].value['taguid'])) {
      EmployeesList.remove(TagsReadings[i].value['taguid']);
      TagsReadings[i].value['Entry/Exit'] = "Sold";
      income = (income + (price)) + ((price) * 0.6);
      TagsReadings[i].value['price'] = price + ((price) * 0.6);
    } else {
      EmployeesList.add((TagsReadings[i].value['taguid']));
      TagsReadings[i].value['Entry/Exit'] = "New Stock";
      expenses = expenses + (price);
      TagsReadings[i].value['price'] = price;
    }

    if (TagsReadings[i].value['IsChecked'] == false &&
        TagsReadings[i].value['Type'] != "Employee") {
      await ChangeQuantity(TagsReadings[i]);
    }
  }
  // return TagsReadings;
  return {'tags': TagsReadings, 'income': income, 'expenses': expenses};
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
