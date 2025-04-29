import 'package:darlink/layout/home_layout.dart';
import 'package:darlink/shared/cubit/app_cubit.dart';
import 'package:darlink/shared/cubit/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> colorOptions = [
    {'name': 'Green', 'color': Colors.green, 'icon': Icons.grass},
    {'name': 'Blue', 'color': Colors.blue, 'icon': Icons.water},
    {'name': 'Red', 'color': Colors.red, 'icon': Icons.favorite},
    {'name': 'Purple', 'color': Colors.purple, 'icon': Icons.brush},
    {'name': 'Orange', 'color': Colors.orange, 'icon': Icons.brightness_5},
    {'name': 'Teal', 'color': Colors.teal, 'icon': Icons.waves},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitState>(
      listener: (context, state) => {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text('Theme Selection'),
            backgroundColor: Colors.green, // Default color
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose App Theme',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Select your preferred color theme',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: colorOptions.map((option) {
                              return _buildColorOption(
                                  option['name'],
                                  option['color'],
                                  option['icon'],
                                  cubit,
                                  context);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildCurrentThemeInfo(cubit, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorOption(
      String name, Color color, IconData icon, cubit, context) {
    return GestureDetector(
      onTap: () {
        cubit.currentColor = name.toLowerCase();
        print('Selected theme: $name');
        Navigator.pushReplacement(
            (context), MaterialPageRoute(builder: (context) => HomeLayout()));
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentThemeInfo(cubit, context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: Icon(Icons.color_lens, color: Colors.grey),
        title: Text('Current Theme'),
        subtitle: Text('${cubit.currentColor} (default)'),
        trailing:
            Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
