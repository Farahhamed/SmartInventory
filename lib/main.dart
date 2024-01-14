import 'package:flutter/material.dart';
import 'package:smartinventory/screens/EmployeeScreen.dart';
import 'package:smartinventory/screens/ProductsScreen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProductsScreen(),
  ));
}

