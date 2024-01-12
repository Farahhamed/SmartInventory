import 'package:smartinventory/models/ProductModel.dart';

class Sales{
  final String date;
  final Product productId;
  final String quantity;

  const Sales(this.date, this.productId, this.quantity);
}