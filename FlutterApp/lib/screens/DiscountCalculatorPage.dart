import 'package:flutter/material.dart';
import 'discount_calculator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiscountCalculatorPage(),
    );
  }
}

class DiscountCalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example usage of DiscountCalculator to calculate the discount rate
    double originalPrice = 100;
    double discountedPrice = 80;
    double discountRate = DiscountCalculator.calculateDiscountRate(
        originalPrice, discountedPrice);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Discount Rate Calculation',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Original Price:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              '\$${originalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Discounted Price:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              '\$${discountedPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Discount Rate:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5),
            Text(
              '${discountRate.toStringAsFixed(2)}%',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
