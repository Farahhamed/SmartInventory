import 'package:smartinventory/models/EmployeeModel.dart';
import 'package:smartinventory/models/ProductModel.dart';

class StockChangeLogs{
  final String date;
  final String time;
  final Product productId;
  final Employee employeeId;

  const StockChangeLogs(this.date, this.time, this.productId, this.employeeId);
}