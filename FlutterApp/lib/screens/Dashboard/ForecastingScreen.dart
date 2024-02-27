import 'package:flutter/material.dart';
import 'package:smartinventory/services/PredictService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class ForecastingScreen extends StatefulWidget {
  @override
  _ForecastingScreenState createState() => _ForecastingScreenState();
}

class _ForecastingScreenState extends State<ForecastingScreen> {
  final List<SalesData> actualResults = [
    SalesData(DateTime(2010), 35),
    SalesData(DateTime(2011), 28),
    SalesData(DateTime(2012), 34),
    SalesData(DateTime(2013), 32),
    SalesData(DateTime(2014), 40)
  ];

  List<SalesData> forecastingResults = [];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchForecastingResults();
  }

  void _fetchForecastingResults() async {
    try {
      List<String> resultList = await PredictService.trainModel();
      // Convert the fetched values to DateTime and double
      DateTime date = DateTime.parse(resultList[0]);
      double predValue = double.parse(resultList[1]);

      setState(() {
        // Clear the previous data and add the fetched data
        forecastingResults.clear();
        forecastingResults.addAll([
          SalesData(date, predValue),
          // Add other forecasted values here if needed
        ]);
      });
    } catch (e) {
      print('Error fetching forecasting results: $e');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Color.fromARGB(255, 158, 125, 249),
        animationDuration: Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, color: Colors.white),
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_graph, color: Colors.white),
              Text('Track', style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings, color: Colors.white),
              Text('Settings',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.white),
              Text('Profile',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Dashboard',
                textAlign: TextAlign.left,
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/user_avatar.jpg'),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Wrap the Column with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Forecasting Results',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!), // Border color
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Line Colors:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              _buildIndicator(
                                  color: Colors.purple, label: 'Actual'),
                              SizedBox(
                                  width: 8), // Adding space between indicators
                              _buildIndicator(
                                  color: Colors.blue, label: 'Forecasting'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(),
                          series: <CartesianSeries>[
                            // Renders spline area chart for actual results
                            SplineAreaSeries<SalesData, DateTime>(
                              dataSource: actualResults,
                              xValueMapper: (SalesData sales, _) => sales.year,
                              yValueMapper: (SalesData sales, _) => sales.sales,
                              name: 'Actual Results',
                              color: Colors.purple
                                  .withOpacity(0.7), // Purple color for lines
                              borderWidth: 3, // Adjust thickness of lines
                              borderColor:
                                  Colors.purple, // Border color for lines
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.withOpacity(
                                      0.3), // Lighter shade for shading
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            // Renders spline area chart for forecasting results
                            SplineAreaSeries<SalesData, DateTime>(
                              dataSource: forecastingResults,
                              xValueMapper: (SalesData sales, _) => sales.year,
                              yValueMapper: (SalesData sales, _) => sales.sales,
                              name: 'Forecasting Results',
                              color: Colors.blue
                                  .withOpacity(0.7), // Blue color for lines
                              borderWidth: 3, // Adjust thickness of lines
                              borderColor:
                                  Colors.blue, // Border color for lines
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withOpacity(
                                      0.2), // Lighter shade for shading
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4), // Adding space between the indicator and the label
        Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class SalesData {
  final DateTime year;
  final double sales;

  SalesData(this.year, this.sales);
}

