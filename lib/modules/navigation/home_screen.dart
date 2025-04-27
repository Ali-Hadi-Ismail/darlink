import 'package:darlink/constants/colors/app_color.dart';
import 'package:darlink/shared/widgets/card/propertyCard.dart';
import 'package:flutter/material.dart';
import 'package:darlink/models/property.dart';
import 'package:darlink/modules/navigation/profile_screen.dart';
import 'package:darlink/shared/widgets/filter_bottom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    Property p = Property(
        title: "Bshamoun",
        price: 100000,
        address: "Bshamoun",
        area: 100,
        bedrooms: 2,
        bathrooms: 3,
        kitchens: 1,
        ownerName: "Ahmad Nasser",
        imageUrl: "assets/images/building.jpg",
        amenities: ["swim pool", "led light"],
        interiorDetails: ["white floor"]);
    return Scaffold(
      backgroundColor: Colors.white, // White background as requested
      appBar: AppBar(
        backgroundColor: AppColors.primary, // Green app bar as requested
        elevation: 0,
        title: Text(
          "Find Properties",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text for better contrast on green
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/mounir.jpg"),
                backgroundColor: Colors.white, // White background for avatar
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Search Field
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search properties...",
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600], // Darker hint text
                      ),
                      filled: true,
                      fillColor: Colors.grey[100], // Light grey background
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.black, // Black text for search
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Button
                ElevatedButton(
                  onPressed: () => showFilterBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Green button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_list, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        "Filters",
                        style: textTheme.labelLarge?.copyWith(
                          color: Colors.white, // White text on green button
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Property List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPropertyCard(context, property: p),
                const SizedBox(height: 16),
                _buildPropertyCard(context, property: p),
                const SizedBox(height: 16),
                _buildPropertyCard(context, property: p),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(BuildContext context,
      {required Property property}) {
    return PropertyCard(
      property: property,
    );
  }
}
