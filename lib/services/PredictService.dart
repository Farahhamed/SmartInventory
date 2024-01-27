import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PredictService {
  static final String baseUrl =
      "http://127.0.0.1:5000"; // Replace with your API URL

  static Future<List<String>> trainModel() async {
    final response = await http.get(Uri.parse('$baseUrl/train'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> result = jsonDecode(response.body);
      Map<String, dynamic> result2 = result[0];
      // Convert "date" string to DateTime
      DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
      DateTime date = dateFormat.parse(result2['date']);

      // Convert "pred_value" to double
      double predValue = result2['pred_value'].toDouble();

      print('Parsed DateTime: $date');
      print('Parsed Double: $predValue');
      print(result2.toString());

      // Convert the dynamic values to doubles
      List<String> resultList = [];
      resultList.add(date.toString());
      resultList.add(predValue.toString());
      return resultList;
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }
}
