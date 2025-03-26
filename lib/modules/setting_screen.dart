import 'package:flutter/material.dart';
import 'package:darlink/constants/colors/app_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Card(
            color: cardBackGroundColor,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: cardPersonColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Personal Profile",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: cardBackGroundColor,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.pink.withOpacity(0.3),
                    child: FaIcon(
                      FontAwesomeIcons.lock,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: cardBackGroundColor,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue.withOpacity(0.3),
                    child: FaIcon(
                      FontAwesomeIcons.shieldHalved,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: cardBackGroundColor,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.yellow.withOpacity(0.3),
                    child: FaIcon(
                      FontAwesomeIcons.mobileAlt,
                      color: Colors.yellow,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Data Saver",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: cardBackGroundColor,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.purple.withOpacity(0.3),
                    child: FaIcon(
                      Icons.notifications,
                      color: Colors.purple,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Notification",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
