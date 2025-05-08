import 'package:flutter/material.dart';

class EventLoadScreen extends StatelessWidget {
  const EventLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}
