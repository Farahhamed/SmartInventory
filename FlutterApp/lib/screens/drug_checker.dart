import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DrugChecker extends StatefulWidget {
  @override
  _DrugCheckerState createState() => _DrugCheckerState();
}

class _DrugCheckerState extends State<DrugChecker> {
  String _result = '';

  Future<void> _retrieveDrugInfo() async {
    final response = await http
        .get(Uri.parse('https://api.fda.gov/drug/drugsfda.json?limit=1'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final drugInfo = data['results'][0];
        final products = drugInfo['products'];
        final brandName =
            products.isNotEmpty ? products[0]['brand_name'] : 'Unknown';
        final genericName =
            brandName; // No generic name provided in the response
        final manufacturer = drugInfo['sponsor_name'] ?? 'Unknown';
        final productNDCs =
            products.map((product) => product['product_number']).join(', ');
        final dosageForm =
            products.isNotEmpty ? products[0]['dosage_form'] : 'Unknown';
        final route = products.isNotEmpty ? products[0]['route'] : 'Unknown';
        final activeIngredients = products.isNotEmpty
            ? products[0]['active_ingredients']
                .map((ingredient) =>
                    '${ingredient['name']} (${ingredient['strength']})')
                .join(', ')
            : 'Unknown';

        final resultText = '''
        Brand Name: $brandName
        Generic Name: $genericName
        Manufacturer: $manufacturer
        Product NDCs: $productNDCs
        Dosage Form: $dosageForm
        Route: $route
        Active Ingredients: $activeIngredients
        ''';

        setState(() {
          _result = resultText;
        });
      } else {
        setState(() {
          _result = 'No drug information found';
        });
      }
    } else {
      setState(() {
        _result = 'Error occurred while retrieving drug information';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open FDA Drug Checker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[300], // Slightly darker grey background color
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _retrieveDrugInfo,
                child: Text(
                  'Retrieve Drug Information',
                  style: TextStyle(fontSize: 18.0),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.purple[200]!), // Soft purple button color
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Drug Information',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _result,
                        style: TextStyle(fontSize: 16.0, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
