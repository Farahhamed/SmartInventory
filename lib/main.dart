import 'package:flutter/material.dart';
import 'package:smartinventory/screens/ProductsList.dart';
import 'package:smartinventory/screens/ProductsScreen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProductsList(),
  ));
}
