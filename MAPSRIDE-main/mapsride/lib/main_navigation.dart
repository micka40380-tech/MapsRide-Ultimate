import 'package:flutter/material.dart';
// Ici, on importera plus tard tes futures pages
import 'map_view.dart';
import 'garage_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Liste des pages à afficher
  final List<Widget> _pages = [
    const MapView(),
    const GarageView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Carte'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Garage'),
        ],
      ), // BottomNavigationBar
    ); // Scaffold
  }
}