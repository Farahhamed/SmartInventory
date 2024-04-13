import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smartinventory/firebase_options.dart';
import 'package:smartinventory/providers/provider.dart';
import 'package:smartinventory/screens/Dashboard/NavBarDashboard.dart';
import 'package:smartinventory/screens/Dashboard/ForecastingScreen.dart';
import 'package:smartinventory/screens/Dashboard/NavBarDashboard.dart';
import 'package:smartinventory/screens/EditProfile.dart';
import 'package:smartinventory/screens/Homepage.dart';
import 'package:smartinventory/screens/LoginScreen.dart';
import 'package:smartinventory/screens/WelcomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    ),
  ));
}
