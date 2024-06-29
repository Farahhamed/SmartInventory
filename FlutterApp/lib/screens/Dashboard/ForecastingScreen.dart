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
        forecastingResults = resultList;
      });

      print('Updated forecastingResults: $forecastingResults');
    } catch (e) {
      print('Error fetching forecasting results: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Forecasting Results for the next 3 months',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 5000000,
                      interval: 500000,
                    ),
                    series: <CartesianSeries>[
                      LineSeries<SalesData, String>(
                        dataSource: forecastingResults,
                        xValueMapper: (SalesData sales, _) =>
                            '${sales.year}-${sales.month.toString().padLeft(2, '0')}',
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        name: 'Forecasting Results',
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          color: Colors.blue,
                          borderWidth: 2,
                          borderColor: Colors.blue,
                        ),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelAlignment: ChartDataLabelAlignment.top,
                          useSeriesColor: true,
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