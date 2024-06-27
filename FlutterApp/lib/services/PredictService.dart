import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smartinventory/models/SalesData.dart';

class PredictService {
  static const String baseUrl =
      "http://127.0.0.1:5000/"; // Replace with your API URL

  static Future<List<SalesData>> trainModel() async {
    final response = await http.get(Uri.parse('$baseUrl/forecast'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> result = jsonDecode(response.body);
      List<SalesData> resultList = [];

      // DateFormat to handle the specific date format
      DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");

      for (var item in result) {
        // Extract year from "date" string
        DateTime date = dateFormat.parse(item['date']);
        int year = date.year;

        // Convert "pred_value" to double
        double predValue = item['pred_value'].toDouble();

        // Create SalesData object and add to list
        resultList.add(SalesData(year, predValue));
      }

      return resultList;
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }
}