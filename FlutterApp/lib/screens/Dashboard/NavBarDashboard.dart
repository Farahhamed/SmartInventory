import 'package:flutter/material.dart';
import 'package:smartinventory/screens/Dashboard/ForecastingScreen.dart';
import 'package:smartinventory/screens/Dashboard/HomeDashboard.dart';
import 'package:smartinventory/screens/StockControl/ABCScreen.dart';
import 'package:smartinventory/screens/StockControl/StockControlScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavbarDashboard extends StatefulWidget {
  @override
  _NavbarDashboardState createState() => _NavbarDashboardState();
}

class _NavbarDashboardState extends State<NavbarDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ForecastingScreen(),
    StockControlPage(),
    ProductDistributionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color.fromARGB(255, 177, 157, 234),
        animationDuration: Duration(milliseconds: 300),
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
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.timeline, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              Text('Forecasting',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.inventory, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              Text('Stock Control',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.pie_chart, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
              Text('Distribution',
                  style: TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}
