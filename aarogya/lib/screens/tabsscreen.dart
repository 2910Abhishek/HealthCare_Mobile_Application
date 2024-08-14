import 'package:aarogya/screens/dashboard.dart';
import 'package:aarogya/screens/healthtracker.dart';
import 'package:aarogya/screens/homescreen.dart';
import 'package:aarogya/screens/recordscreen.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = HomeScreen();
    var activePageTitle = 'Home';
    if (_selectedPageIndex == 1) {
      activePage = RecordScreen();
      activePageTitle = 'Health Records';
    }
    if (_selectedPageIndex == 2) {
      activePage = HealthTracker();
      activePageTitle = 'Track Changes';
    }
    if (_selectedPageIndex == 3) {
      activePage = DashBoardScreen();
      activePageTitle = 'DashBoard';
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Set the type to fixed
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.recent_actors_rounded), label: 'Health Records'),
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_outlined), label: 'Track Changes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize), label: 'Dashboard'),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: activePage,
            ),
          ),
        ],
      ),
    );
  }
}
