import 'package:darlink/layout/home_layout.dart';
import 'package:darlink/modules/intro_screens/budget_screen.dart';
import 'package:darlink/modules/profile_screen.dart';
import 'package:darlink/modules/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darlink',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: RegisterScreen(),
    );
  }
}
