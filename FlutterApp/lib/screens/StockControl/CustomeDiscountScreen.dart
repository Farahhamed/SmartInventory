import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/services/ProductsService.dart';

class DiscountCalculator {
  // Function to calculate the discount rate
  static double calculateDiscountRate(
      double originalPrice, double discountedPrice) {
    // Calculate the discount rate using the formula: (originalPrice - discountedPrice) / originalPrice * 100
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }
}

class AddDiscountPage extends StatefulWidget {
  @override
  _AddDiscountPageState createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends State<AddDiscountPage> {
  late ProductService productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Discount'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<List<Product>>(
          stream: productService.getProduct(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products = snapshot.data!;

              // Filter out products that have already been discounted
              products = products
                  .where((product) => !product.discountApplied)
                  .toList();

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return DiscountCard(product: products[index]);
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class DiscountCard extends StatefulWidget {
  final Product product;

  const DiscountCard({required this.product, Key? key}) : super(key: key);

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  late TextEditingController _discountController;
  String? _discountErrorText;
  late double originalPrice;

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController();
    originalPrice = double.parse(widget.product.price);
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _validateDiscount(String value) {
    setState(() {
      if (value.isEmpty) {
        _discountErrorText = 'Please enter a discount rate';
      } else if (!RegExp(r'^[1-9][0-9]?$|^100$').hasMatch(value)) {
        _discountErrorText = 'Please enter a value between 1 and 100';
      } else {
        _discountErrorText = null;
      }
    });
  }

  void _showDiscountedPrice(double discountRate) {
    final double discountedPrice =
        originalPrice - (originalPrice * (discountRate / 100));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Discounted Price'),
          content: Text(
              'The discounted price is \$${discountedPrice.toStringAsFixed(2)}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Apply discount action here
                _applyDiscount(discountRate, discountedPrice);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[200]),
              ),
              child: Text(
                'Apply',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _applyDiscount(
      double discountRate, double discountedPrice) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('Discounts');

      // Save the discount data to Firestore
      await collectionRef.add({
        'name': widget.product.name,
        'price': widget.product.price,
        'afterprice': discountedPrice.toString(),
        'percentage': discountRate.toString(),
        'imageUrl': widget.product.imageUrl,
        'orderDateTime': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The discount is applied successfully'),
        ),
      );

      // Notify the parent widget to remove the product from the list
      // For simplicity, you can directly remove the product here if you have access to the list
      setState(() {
        widget.product.discountApplied = true;
      });
    } catch (e) {
      print('Error saving discount: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to apply discount'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Color.fromRGBO(246, 245, 242, 1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          color: Color.fromRGBO(112, 66, 100, 1),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Discount Rate (%)',
                          errorText: _discountErrorText,
                        ),
                        onChanged: _validateDiscount,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_discountErrorText == null) {
                          final double discountRate =
                              double.parse(_discountController.text);
                          _showDiscountedPrice(discountRate);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Color.fromRGBO(112, 66, 100, 1), disabledForegroundColor: Colors.red.shade200.withOpacity(0.38), disabledBackgroundColor: Colors.red.shade200.withOpacity(0.12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 40,
                        child: Text(
                          'Add a discount',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AddDiscountPage(),
  ));
}
