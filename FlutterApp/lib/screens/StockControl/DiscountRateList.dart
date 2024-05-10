import 'package:flutter/material.dart';

class DiscountList extends StatefulWidget {
  const DiscountList({super.key});

  @override
  State<DiscountList> createState() => _DiscountListState();
}

class _DiscountListState extends State<DiscountList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discounts availble"),
      ),
    );
  }
}
