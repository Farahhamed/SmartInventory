import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeesService {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/get_employees'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addEmployee(String employeeName, String job_title) async {
    final url = Uri.parse('http://127.0.0.1:5000/add_employee');

    try {
      final employeeData = {
        'name': employeeName,
        'job_title': job_title,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employeeData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(
            'Product added successfully. Product ID: ${responseData['employee_id']}');
        // You can add any further actions or UI updates here
      } else {
        print('Failed to add product. Status code: ${response.statusCode}');
        // Handle error cases or display a message to the user
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
