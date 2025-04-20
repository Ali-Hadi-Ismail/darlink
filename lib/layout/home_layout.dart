import 'package:darlink/constants/colors/app_color.dart';
import 'package:darlink/modules/home_screen.dart';
import 'package:darlink/modules/message_screen.dart';
import 'package:darlink/modules/profile_screen.dart';
import 'package:darlink/modules/setting_screen.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    Center(
      child: Text(
        'Search Page',
        style: TextStyle(color: Colors.white),
      ),
    ),
    const ProfileScreen(),
    const MessageScreen(),
    const SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBottomNavigationBarItem({
    required IconData icon,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isSelected ? 50 : 40, // Bubble effect
            width: isSelected ? 50 : 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.purpleAccent.withOpacity(0.4)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: (isSelected) ? Colors.purple.shade900 : Colors.purple,
                size: isSelected ? 30 : 25),
          ),
          const SizedBox(height: 4),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isSelected ? 1.0 : 0.0,
            child: Container(
              height: 4,
              width: 4,
              decoration: const BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500), // Smooth page transition
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), // Rounded top corners
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavigationBarItem(icon: Icons.home, index: 0),
            _buildBottomNavigationBarItem(icon: Icons.search, index: 1),
            _buildBottomNavigationBarItem(icon: Icons.person, index: 2),
            _buildBottomNavigationBarItem(icon: Icons.message, index: 3),
            _buildBottomNavigationBarItem(icon: Icons.settings, index: 4),
          ],
        ),
      ),
    );
  }
}
