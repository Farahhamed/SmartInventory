// discount_calculator.dart

class DiscountCalculator {
  // Function to calculate the discount rate
  static double calculateDiscountRate(
      double originalPrice, double discountedPrice) {
    // Calculate the discount rate using the formula: (originalPrice - discountedPrice) / originalPrice * 100
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }
}
