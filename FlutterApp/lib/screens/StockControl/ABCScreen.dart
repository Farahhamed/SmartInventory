import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/screens/AccessMonitoring.dart';
import 'package:smartinventory/services/ProductsService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  Map<Product, int> turnoverMap = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    products = await productService.getProduct().first;
    productDistribution = await categorizeProducts();
    print(productDistribution);
    setState(() {
      isLoading = false; // Set loading flag to false after data is fetched
    });
  }

  Future<void> getProductsTurnover() async {
    List<MapEntry<String, dynamic>> productStates = await masterFunction();
    Map<String, int> productsEntry = {};
    Map<String, int> productsExit = {};
    Map<String, int> productsTurnover = {};
    for (var product in productStates) {
      if (product.value["Type"] == "Product") {
        String? productId = await getProductByUID(product.value["taguid"]);
        if (product.value["Entry/Exit"] == "Entry") {
          if (productsEntry.containsKey(productId)) {
            productsEntry[productId!] = productsEntry[productId]! + 1;
          } else {
            productsEntry[productId!] = 0;
          }
        } else {
          if (productsExit.containsKey(productId)) {
            productsExit[productId!] = productsExit[productId]! + 1;
          } else {
            productsExit[productId!] = 0;
          }
        }
      }
      for (var entry in productsEntry.entries) {
        if (!productsExit.containsKey(entry.key)) {
          productsTurnover[entry.key] = 0;
        } else {
          productsTurnover[entry.key] =
              (productsEntry[entry.key]! > productsExit[entry.key]!)
                  ? productsExit[entry.key]!
                  : productsEntry[entry.key]!;
        }
      }
    }
    Map<Product, int> turnover = {};
    for (var product in productsTurnover.entries) {
      Product p = await productService.getProductById(product.key);
      turnover[p] = product.value;
    }
    // Convert the map entries to a list
    List<MapEntry<Product, int>> entries = turnover.entries.toList();

    // Sort the list based on values
    entries.sort((a, b) => a.value.compareTo(b.value));

    // Optionally, create a new map from the sorted list
    Map<Product, int> sortedMap = Map.fromEntries(entries);

    // Printing the sorted map
    sortedMap.forEach((key, value) {
      print('${key}: $value');
    });

    turnoverMap = sortedMap;
  
  }

  Future<String?> getProductByUID(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Assigned_Products')
          .where('UID', isEqualTo: uid)
          .get();

      return snapshot.docs.first["ProductId"];
    } catch (e) {
      print("Error fetchin UID data");
      print(e);
      throw e;
    }
  }

  Future<Map<String, int>> categorizeProducts() async {
    await getProductsTurnover();
    int countA = (turnoverMap.length * 0.2).round();
    int countB = (turnoverMap.length * 0.3).round();
    int countC = turnoverMap.length - (countA + countB);

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
        title: const Center(child: Text('Product Distribution')),
      ),
      body: isLoading
          ? const Center(
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
        _getProductsForCategory();
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
                      style: const TextStyle(
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

  Map<String, List<Product>> _getProductsForCategory() {

    int countA = (turnoverMap.length * 0.2).round();
    int countB = (turnoverMap.length * 0.3).round();

    List<Product> categoryProducts = [];
    Map<String, List<Product>> c = {};
    var entries = turnoverMap.entries.toList();

    for (int i = 0; i < turnoverMap.length; i++) {
      var entry = entries[i];
      if (i == countA) {
        c["Category A"] = categoryProducts;
        categoryProducts = [];
      }
      if (i == countB + countA) {
        c["Category B"] = categoryProducts;
        categoryProducts = [];
      }
      categoryProducts.add(entry.key);
    }
    c["Category C"] = categoryProducts;

    return c;
  }
}
