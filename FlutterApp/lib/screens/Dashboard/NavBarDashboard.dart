import 'package:flutter/material.dart';
import 'package:smartinventory/screens/Dashboard/ForecastingScreen.dart';
import 'package:smartinventory/screens/Dashboard/HomeDashboard.dart';
import 'package:smartinventory/screens/StockControl/ABCScreen.dart';
import 'package:smartinventory/screens/StockControl/FifoLifoScreen.dart';
import 'package:smartinventory/screens/StockControl/FifoScreenFrontend.dart';
import 'package:smartinventory/screens/StockControl/StockControlScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavbarDashboard extends StatefulWidget {
  const NavbarDashboard({Key? key}) : super(key: key);

  @override
  _NavbarDashboardState createState() => _NavbarDashboardState();
}

class _NavbarDashboardState extends State<NavbarDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ForecastingScreen(),
    StockControlPage(),
    ProductDistributionPage(),
    FIFOInventoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color.fromRGBO(66, 125, 157, 1),
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timeline, color: Colors.white),
              Text('Forecasting',
                  style: TextStyle(color: Colors.white, fontSize: 7)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart, color: Colors.white),
              Text('Stock Control',
                  style: TextStyle(color: Colors.white, fontSize: 7)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory, color: Colors.white),
              Text('Distribution',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.production_quantity_limits, color: Colors.white),
              Text('Fifo', style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}
