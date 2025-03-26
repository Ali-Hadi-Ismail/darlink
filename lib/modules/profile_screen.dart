import 'package:flutter/material.dart';
import 'package:darlink/constants/colors/app_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          'Owner Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Card(
            color: cardBackGroundColor,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green.shade700.withOpacity(0.5),
                    child: FaIcon(
                      FontAwesomeIcons.rightFromBracket,
                      color: Colors.greenAccent,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
