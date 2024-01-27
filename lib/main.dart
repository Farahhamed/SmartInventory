import 'package:flutter/material.dart';

import 'package:smartinventory/screens/PredictScreen.dart';

import 'package:smartinventory/screens/EmployeeScreen.dart';

import 'package:smartinventory/screens/ProductsScreen.dart';
import 'package:smartinventory/screens/ProfileScreen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileScreen(),
  ));
}
