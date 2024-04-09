import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smartinventory/firebase_options.dart';
import 'package:smartinventory/providers/provider.dart';
import 'package:smartinventory/screens/Dashboard/ForecastingScreen.dart';
import 'package:smartinventory/screens/Dashboard/NavBarDashboard.dart';
import 'package:smartinventory/screens/EditProfile.dart';
import 'package:smartinventory/screens/LoginScreen.dart';
import 'package:smartinventory/screens/NavigationBarScreen.dart';
import 'package:smartinventory/screens/Notification.dart';
import 'package:smartinventory/screens/ProductsList.dart';
import 'package:smartinventory/screens/ProductsScreen.dart';
import 'package:smartinventory/screens/ProfileScreen.dart';
import 'package:smartinventory/screens/SignUpScreen.dart';
import 'package:smartinventory/screens/StockControl/ABCScreen.dart';
import 'package:smartinventory/screens/StockControl/stockControlScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditProfilePage(),
    ),
  ));
}
