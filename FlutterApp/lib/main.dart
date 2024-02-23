import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:smartinventory/screens/Dashboard/ForecastingScreen.dart';
import 'package:smartinventory/screens/NavigationBarScreen.dart';
// import 'package:smartinventory/screens/ProductsList.dart';
// import 'package:smartinventory/screens/ProductsScreen.dart';
// import 'package:smartinventory/screens/SignUpScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
  ));
}
