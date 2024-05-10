import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/services/ProductsService.dart';

class ProductDistributionPage extends StatefulWidget {
  const ProductDistributionPage({Key? key}) : super(key: key);

  @override
  _ProductDistributionPageState createState() =>
      _ProductDistributionPageState();
}

class _ProductDistributionPageState extends State<ProductDistributionPage> {
  late Map<String, int> productDistribution;
  late List<Product> products; // Updated type
  final ProductService productService = ProductService(); // Updated service
  late double thresholdA;
  late double thresholdB;
  bool isLoading = true; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    products = await productService.getProduct().first;
    calculateThresholds();
    productDistribution = categorizeProducts(products);
    setState(() {
      isLoading = false; // Set loading flag to false after data is fetched
    });
  }

  void calculateThresholds() {
    double totalPrice = products.fold(
        0,
        (previousValue, element) =>
            previousValue +
            double.parse(element.price)); // Updated to use price

    thresholdA = totalPrice * 0.2;
    thresholdB = totalPrice * 0.4;
  }

  Map<String, int> categorizeProducts(List<Product> products) {
    products.sort((a, b) => double.parse(b.price)
        .compareTo(double.parse(a.price))); // Updated to use price

    int countA = 0;
    int countB = 0;
    int countC = 0;

    for (var product in products) {
      if (double.parse(product.price) >= thresholdA) {
        // Updated to use price
        countA++;
      } else if (double.parse(product.price) >= thresholdB &&
          double.parse(product.price) < thresholdA) {
        // Updated to use price
        countB++;
      } else {
        countC++;
      }
    }

    return {
      'Category A': countA,
      'Category B': countB,
      'Category C': countC,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Product Distribution')),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator()) // Show indicator when loading
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: const Color(0xFFF3E5F5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ListTile(
                        title: Text(
                          'Product Distribution',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'The importance of the current products based on ABC method',
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 300,
                          child: PieChart(
                            PieChartData(
                              sections: _getSections(productDistribution),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildLegend('A', Colors.redAccent),
                                _buildLegend('B', Colors.amberAccent),
                                _buildLegend('C', Colors.lightBlueAccent),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _showDetailsDialog(
                                    productDistribution, products);
                              },
                              child: const Text('See Details'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  List<PieChartSectionData> _getSections(Map<String, int> distribution) {
    List<PieChartSectionData> sections = [];
    distribution.forEach((category, count) {
      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: count.toString(),
          color: _getColorForCategory(category),
          radius: 100,
        ),
      );
    });
    return sections;
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Category A':
        return Colors.redAccent.withOpacity(0.7);
      case 'Category B':
        return Colors.amberAccent.withOpacity(0.7);
      case 'Category C':
        return Colors.lightBlueAccent.withOpacity(0.7);
      default:
        return Colors.grey;
    }
  }

  Widget _buildLegend(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(
      Map<String, int> distribution, List<Product> products) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Product Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: distribution.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ..._getProductsForCategory(entry.key, products),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _getProductsForCategory(
      String category, List<Product> products) {
    List<Widget> productWidgets = [];

    // Filter products based on category
    List<Product> categoryProducts = [];
    switch (category) {
      case 'Category A':
        categoryProducts = products.where((product) {
          return double.parse(product.price) >= thresholdA;
        }).toList();
        break;
      case 'Category B':
        categoryProducts = products.where((product) {
          return double.parse(product.price) >= thresholdB &&
              double.parse(product.price) < thresholdA;
        }).toList();
        break;
      case 'Category C':
        categoryProducts = products.where((product) {
          return double.parse(product.price) < thresholdB &&
              double.parse(product.price) < thresholdA;
        }).toList();
        break;
    }

    // Add product widgets
    categoryProducts.forEach((product) {
      productWidgets.add(
        ListTile(
          title: Text(product.name),
          subtitle: Text('Price: \$${product.price}'),
        ),
      );
    });

    return productWidgets;
  }
}
