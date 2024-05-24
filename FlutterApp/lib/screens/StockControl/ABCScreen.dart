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
    productDistribution = categorizeProducts(products);
    print(productDistribution);
    setState(() {
      isLoading = false; // Set loading flag to false after data is fetched
    });
  }

  Map<String, int> categorizeProducts(List<Product> products) {
    int countA = (products.length * 0.2).round();
    int countB = (products.length * 0.3).round();
    int countC = products.length - (countA + countB);

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
    Map<String, List<Product>> categorizedProducts =
        _getProductsForCategory(products);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Product Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categorizedProducts.entries.map((entry) {
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
                    Column(
                      children: entry.value.map((product) {
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                              'Price: \$${product.price}'), // Format price to display with two decimal places
                        );
                      }).toList(),
                    ),
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

  Map<String, List<Product>> _getProductsForCategory(List<Product> products) {
    products
        .sort((a, b) => double.parse(b.price).compareTo(double.parse(a.price)));

    int countA = (products.length * 0.2).round();
    int countB = (products.length * 0.3).round();

    List<Product> categoryProducts = [];
    Map<String, List<Product>> c = {};

    for (int i = 0; i < products.length; i++) {
      if (i == countA) {
        c["Category A"] = categoryProducts;
        categoryProducts = [];
      }
      if (i == countB + countA) {
        c["Category B"] = categoryProducts;
        categoryProducts = [];
      }
      categoryProducts.add(products[i]);
    }
    c["Category C"] = categoryProducts;

    return c;
  }
}
