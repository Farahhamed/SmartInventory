class SalesData {
  final int year;
  final int month;
  final double sales;

  SalesData(this.year, this.month, this.sales);

  @override
  String toString() {
    return 'SalesData{year: $year, month: $month, sales: $sales}';
  }
}