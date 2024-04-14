import 'package:flutter/material.dart';
import 'package:smartinventory/screens/Dashboard/ForecastingScreen.dart';
import 'package:smartinventory/screens/Dashboard/HomeDashboard.dart';
import 'package:smartinventory/screens/StockControl/ABCScreen.dart';
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
    HomeScreen(),
    ForecastingScreen(),
    StockControlPage(),
    const ProductDistributionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 177, 157, 234),
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, color: Colors.white),
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timeline, color: Colors.white),
              Text('Forecasting',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory, color: Colors.white),
              Text('Stock Control',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart, color: Colors.white),
              Text('Distribution',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}
