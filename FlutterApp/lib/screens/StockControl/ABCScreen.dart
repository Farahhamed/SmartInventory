import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart library for pie chart

class ProductDistributionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for product distribution (replace with actual data)
    Map<String, int> productDistribution = {
      'Category A': 30,
      'Category B': 40,
      'Category C': 30,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Distribution'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Color(0xFFF3E5F5), // Light pastel purple background color
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Product Distribution',
                    style: TextStyle(
                        fontWeight: FontWeight.bold), // Make title bold
                  ),
                  subtitle: Text(
                    'The importance of the current products based on ABC method',
                    style: TextStyle(
                        color: Colors.purple), // Purple subtitle text color
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 300, // Set height for the pie chart
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
                          _buildLegend(
                              'A', Colors.redAccent), // Pastel red color
                          _buildLegend(
                              'B', Colors.amberAccent), // Pastel yellow color
                          _buildLegend(
                              'C', Colors.lightBlueAccent), // Pastel blue color
                        ],
                      ),
                      SizedBox(
                          height: 16), // Add space between legend and button
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press to see details
                        },
                        child: Text('See Details'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16), // Add space at the bottom of the card
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create pie chart sections
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

  // Helper method to get color for each category
  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Category A':
        return Colors.redAccent
            .withOpacity(0.7); // Lighter shade of red with opacity
      case 'Category B':
        return Colors.amberAccent
            .withOpacity(0.7); // Lighter shade of yellow with opacity
      case 'Category C':
        return Colors.lightBlueAccent
            .withOpacity(0.7); // Lighter shade of blue with opacity
      default:
        return Colors.grey;
    }
  }

  // Helper method to build legend for each category
  Widget _buildLegend(String label, Color color) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          SizedBox(width: 8),
          Text(
            label,
            style:
                TextStyle(fontWeight: FontWeight.bold), // Make legend item bold
          ),
        ],
      ),
    );
  }
}
