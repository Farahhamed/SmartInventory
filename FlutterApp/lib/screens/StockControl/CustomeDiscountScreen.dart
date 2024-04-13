import 'package:flutter/material.dart';

class AddDiscountPage extends StatefulWidget {
  @override
  _AddDiscountPageState createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends State<AddDiscountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text('Add Discount'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: const [
            SizedBox(height: 10),
            DiscountCard(
              productName: 'Product A',
              productImage: 'assets/product_a.jpg',
            ),
            SizedBox(height: 10),
            DiscountCard(
              productName: 'Product B',
              productImage: 'assets/product_b.jpg',
            ),
            SizedBox(height: 10),
            DiscountCard(
              productName: 'Product C',
              productImage: 'assets/product_c.jpg',
            ),
          ],
        ),
      ),
    );
  }
}

class DiscountCard extends StatefulWidget {
  final String productName;
  final String productImage;

  const DiscountCard({
    Key? key,
    required this.productName,
    required this.productImage,
  }) : super(key: key);

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  late TextEditingController _discountController;
  String? _discountErrorText;

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController();
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
      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        _discountErrorText = 'Please enter only numeric values';
      } else {
        _discountErrorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150, // Adjust height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.productImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.productName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
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
                        // Discount functionality here
                        print('Discount added: ${_discountController.text}%');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, // No padding
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 40,
                      child: Text(
                        'Put on discount',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddDiscountPage(),
  ));
}
