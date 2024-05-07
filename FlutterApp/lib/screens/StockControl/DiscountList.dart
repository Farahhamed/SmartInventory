import 'package:flutter/material.dart';

class CouponShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Discounts Available'),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: 400,
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromRGBO(240, 235, 227, 1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.transparent, width: 1),
              ),
            ),
            Positioned(
              left: -17,
              top: 50,
              child: CustomPaint(
                size: Size(20, 50),
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
                  // First part: Image with half-circle overlay on the left
                  Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(25),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 233, 233, 233),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.transparent, width: 1),
                              ),
                              child: Image.asset(
                                'assets/images/vitaminE.png',
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
                    width: 50,
                    height: 150,
                    child: CustomPaint(
                      painter: DottedLinePainter(),
                    ),
                  ),

                  // Last part: Text
                  const Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '50% OFF',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Product Name',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    '\$100',
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '\$50',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Expires on: 31 May 2024',
                                style: TextStyle(fontSize: 12),
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
      ..color = Colors.white // Change color to purple
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
