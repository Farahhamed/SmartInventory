import 'package:flutter/material.dart';
import 'package:smartinventory/models/ProductModel.dart';
import 'package:smartinventory/models/SalesModel.dart';
import 'package:smartinventory/screens/StockControl/CustomeDiscountScreen.dart';
import 'package:smartinventory/services/DiscountService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CouponShape extends StatefulWidget {
  @override
  _CouponShapeState createState() => _CouponShapeState();
}

class _CouponShapeState extends State<CouponShape> {
  final DiscountService discountService = DiscountService();
  List<Map<String, dynamic>> finalproducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    var data = await discountService.getDiscount();
    setState(() {
      finalproducts = (data as List<MapEntry<String, dynamic>>)
          .map((entry) => entry.value as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Discounts Available'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: finalproducts.isNotEmpty
                  ? ListView.builder(
                      itemCount: finalproducts.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> productEntry =
                            finalproducts[index];
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: 400,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(240, 235, 227, 1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.transparent, width: 1),
                                  ),
                                ),
                                Positioned(
                                  left: -17,
                                  top: 50,
                                  child: CustomPaint(
                                    size: const Size(20, 50),
                                    painter: HalfCirclePainter(),
                                  ),
                                ),
                                Positioned(
                                  right: -17,
                                  top: 50,
                                  child: CustomPaint(
                                    size: const Size(20, 50),
                                    painter: HalfCirclePainterRight(),
                                  ),
                                ),
                                Container(
                                  width: 400,
                                  height: 150,
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 233, 233, 233),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      color: Colors.transparent,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Image.network(
                                                    productEntry[
                                                        'imageUrl'], // Product image URL
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Middle part: Dotted line
                                      Container(
                                        width: 10,
                                        height: 150,
                                        child: CustomPaint(
                                          painter: DottedLinePainter(),
                                        ),
                                      ),

                                      // Last part: Text
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${productEntry['percentage']}% OFF', // Update with discount's percentage
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${productEntry['name']}', // Placeholder for product name
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '\EGP${productEntry['price']}', // Placeholder for original price
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        '\EGP${productEntry['afterprice']}', // Update with discount's discounted price
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    'Expires on: ${(productEntry['discountExpire'] as Timestamp).toDate()}', // Update with discount's expiration date
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
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
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to AddDiscountPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDiscountPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Add Discount',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(112, 66, 100, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final dashWidth = 3;
    final dashSpace = 3;

    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // Change style to fill

    final centerX = size.width / 2;
    final radius = size.height / 2;

    final path = Path()
      ..moveTo(centerX, radius)
      ..arcTo(
        Rect.fromCircle(center: Offset(centerX, radius), radius: radius),
        -0.5 * 3.14, // -0.5 * pi to draw the left half-circle
        3.14, // 180 degrees
        true,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HalfCirclePainterRight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Change color to purple
      ..style = PaintingStyle.fill; // Change style to fill

    final centerX = size.width / 2;
    final radius = size.height / 2;

    final path = Path()
      ..moveTo(centerX, radius)
      ..arcTo(
        Rect.fromCircle(center: Offset(centerX, radius), radius: radius),
        0.5 * 3.14, // 0.5 * pi for 90 degrees
        3.14, // 180 degrees
        true,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CouponShape(),
  ));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:smartinventory/screens/StockControl/CustomeDiscountScreen.dart';

// class CouponShape extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Discounts Available'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             buildCouponContainer(),
//             SizedBox(height: 20),
//             buildCouponContainer(),
//             SizedBox(height: 20),
//             buildCouponContainer(),
//             SizedBox(height: 20),
//             // Add the button here
//             Center(
//               child: SizedBox(
//                 width: 150,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Navigate to another page
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => AddDiscountPage()));
//                   },
//                   child: const Text('Add Product'),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: Color.fromRGBO(112, 66, 100, 1),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildCouponContainer() {
//     return Center(
//       child: Stack(
//         children: [
//           Container(
//             width: 400,
//             height: 150,
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(240, 235, 227, 1),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: Colors.transparent, width: 1),
//             ),
//           ),
//           Positioned(
//             left: -17,
//             top: 50,
//             child: CustomPaint(
//               size: Size(20, 50),
//               painter: HalfCirclePainter(),
//             ),
//           ),
//           Positioned(
//             right: -17,
//             top: 50,
//             child: CustomPaint(
//               size: const Size(20, 50),
//               painter: HalfCirclePainterRight(),
//             ),
//           ),
//           Container(
//             width: 400,
//             height: 150,
//             child: Row(
//               children: [
//                 // First part: Image with half-circle overlay on the left
//                 Stack(
//                   children: [
//                     Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(25),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Container(
//                             width: 100,
//                             height: 100,
//                             decoration: BoxDecoration(
//                               color: const Color.fromARGB(255, 233, 233, 233),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                   color: Colors.transparent, width: 1),
//                             ),
//                             child: Image.asset(
//                               'assets/images/vitimanE.png',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Middle part: Dotted line
//                 Container(
//                   width: 50,
//                   height: 150,
//                   child: CustomPaint(
//                     painter: DottedLinePainter(),
//                   ),
//                 ),

//                 // Last part: Text
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: Stack(
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               '50% OFF',
//                               style: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               'Product Name',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               children: [
//                                 Text(
//                                   '\$100',
//                                   style: TextStyle(
//                                       decoration: TextDecoration.lineThrough),
//                                 ),
//                                 SizedBox(width: 5),
//                                 Text(
//                                   '\$50',
//                                   style: TextStyle(color: Colors.green),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               'Expires on: 31 May 2024',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DottedLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.grey
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round;

//     final dashWidth = 3;
//     final dashSpace = 3;

//     double startY = 0;

//     while (startY < size.height) {
//       canvas.drawLine(
//         Offset(size.width / 2, startY),
//         Offset(size.width / 2, startY + dashWidth),
//         paint,
//       );
//       startY += dashWidth + dashSpace;
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class HalfCirclePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white // Change color to purple
//       ..style = PaintingStyle.fill; // Change style to fill

//     final centerX = size.width / 2;
//     final radius = size.height / 2;

//     final path = Path()
//       ..moveTo(centerX, radius)
//       ..arcTo(
//         Rect.fromCircle(center: Offset(centerX, radius), radius: radius),
//         -0.5 * 3.14, // -0.5 * pi to draw the left half-circle
//         3.14, // 180 degrees
//         true,
//       );

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class HalfCirclePainterRight extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white // Change color to purple
//       ..style = PaintingStyle.fill; // Change style to fill

//     final centerX = size.width / 2;
//     final radius = size.height / 2;

//     final path = Path()
//       ..moveTo(centerX, radius)
//       ..arcTo(
//         Rect.fromCircle(center: Offset(centerX, radius), radius: radius),
//         0.5 * 3.14, // 0.5 * pi for 90 degrees
//         3.14, // 180 degrees
//         true,
//       );

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: CouponShape(),
//   ));
// }
