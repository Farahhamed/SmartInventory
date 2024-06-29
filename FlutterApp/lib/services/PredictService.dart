import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smartinventory/models/SalesData.dart';

class PredictService {
  static const String baseUrl = "http://127.0.0.1:5000/"; // Replace with your API URL

  static Future<List<SalesData>> trainModel() async {
    final response = await http.get(Uri.parse('$baseUrl/forecast'));

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      List<SalesData> resultList = [];

      DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");

      for (var item in result) {
        DateTime date = dateFormat.parse(item['date']);
        int year = date.year;
        int month = date.month;
        double predValue = item['pred_value'].toDouble();

        resultList.add(SalesData(year, month, predValue));
      }

      return resultList;
    } else {
      throw Exception('Failed to load data');
    }
  }
}