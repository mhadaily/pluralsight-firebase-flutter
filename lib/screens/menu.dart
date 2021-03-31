// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:wiredbrain/screens/cart.dart';
import 'package:wiredbrain/services/services.dart';
import 'package:wiredbrain/widgets/cart_badge.dart';

import 'profile.dart';
import 'orders.dart';
import './menu_list.dart';

class MenuScreen extends StatefulWidget {
  static String routeName = 'menuScreen';
  static Route<MenuScreen> route() {
    return MaterialPageRoute<MenuScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => MenuScreen(),
    );
  }

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> tabs = [
    MenuList(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  final FirebaseAnalyticsObserver observer = AnalyticsService.observer;

  void _sendCurrentTabToAnalytics() {
    final String screeName = '${MenuScreen.routeName}/tab$_selectedIndex';
    observer.analytics.setCurrentScreen(
      screenName: screeName,
    );
    print('Logged $screeName');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _sendCurrentTabToAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Welcome to the WiredBrain"),
        centerTitle: false,
        actions: [
          CartBadge(
            top: 8,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
          ),
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.brown.shade300,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Menu",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown.shade800,
        onTap: _onItemTapped,
      ),
    );
  }
}
