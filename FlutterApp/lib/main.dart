import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smartinventory/firebase_options.dart';
import 'package:smartinventory/providers/provider.dart';
import 'package:smartinventory/screens/AssignProduct.dart';
import 'package:smartinventory/screens/NavigationBarScreen.dart';
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
      home: AuthenticationWrapper(),
    ),
  ));
}


class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});
  @override
  Widget build(BuildContext context) {

    // Check if the user is authenticated
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null ? MyHomePage() : WelcomeScreen();
  }
}