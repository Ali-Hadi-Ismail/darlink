import 'package:darlink/layout/home_layout.dart';
import 'package:darlink/modules/admin/admin_dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DarLinkApp());
}

class DarLinkApp extends StatelessWidget {
  const DarLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darlink',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: AdminDashboard(),
    );
  }
}
