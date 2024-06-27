import 'package:flutter/material.dart';
import 'package:smartinventory/models/SalesData.dart';
import 'package:smartinventory/services/PredictService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ForecastingScreen extends StatefulWidget {
  const ForecastingScreen({super.key});

  @override
  _ForecastingScreenState createState() => _ForecastingScreenState();
}

class _ForecastingScreenState extends State<ForecastingScreen> {
  List<SalesData> forecastingResults = [];

  @override
  void initState() {
    super.initState();
    _fetchForecastingResults();
  }

  void _fetchForecastingResults() async {
    try {
      List<SalesData> resultList = await PredictService.trainModel();

      setState(() {
        // Update the forecastingResults with the fetched data
        forecastingResults = resultList;
      });

      // Print the parsed data for debugging
      print('Updated forecastingResults: $forecastingResults');
    } catch (e) {
      print('Error fetching forecasting results: $e');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding to the entire page
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: const Text('Dashboard'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Wrap the Column with SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Forecasting Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey[300]!), // Border color
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: SfCartesianChart(
                    primaryXAxis: NumericAxis(
                      minimum: 2013,
                      maximum: 2025,
                      interval: 2,
                      numberFormat: NumberFormat('####'),
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 5000000,
                      interval: 500000,
                    ),
                    series: <CartesianSeries>[
                      ScatterSeries<SalesData, int>(
                        dataSource: forecastingResults,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        name: 'Forecasting Results',
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType
                              .circle, // Change marker shape if needed
                          color: Colors.blue, // Marker color
                          borderWidth: 2, // Marker border width
                          borderColor: Colors.blue, // Marker border color
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
