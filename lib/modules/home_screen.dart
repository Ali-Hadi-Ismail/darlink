import 'package:darlink/constants/colors/app_color.dart';
import 'package:darlink/modules/profile_screen.dart';
import 'package:darlink/shared/widgets/propertyCard.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          "Home Screen",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/mounir.jpg",
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar and Filter Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Search Field
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search properties...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                // Filter Button
                ElevatedButton(
                  onPressed: () {
                    // Add filter functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Purple background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          "Filters",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Property List
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PropertyCard(
                    imageUrl: 'assets/images/building.jpg',
                    name: 'Luxury Villa',
                    price: 2500.00,
                    address: '123 Palm Street, Miami, FL',
                    size: 1800,
                    bedrooms: 3,
                    bathrooms: 2,
                    kitchens: 1,
                  ),
                  PropertyCard(
                    imageUrl: 'assets/images/building.jpg',
                    name: 'Modern Apartment',
                    price: 1500.00,
                    address: '456 Ocean Drive, Los Angeles, CA',
                    size: 1200,
                    bedrooms: 2,
                    bathrooms: 1,
                    kitchens: 1,
                  ),
                  PropertyCard(
                    imageUrl: 'assets/images/building.jpg',
                    name: 'Cozy Cottage',
                    price: 1800.00,
                    address: '789 Maple Lane, Denver, CO',
                    size: 1400,
                    bedrooms: 3,
                    bathrooms: 2,
                    kitchens: 1,
                  ),
                  PropertyCard(
                    imageUrl: 'assets/images/building.jpg',
                    name: 'Cozy Cottage',
                    price: 1800.00,
                    address: '789 Maple Lane, Denver, CO',
                    size: 1400,
                    bedrooms: 3,
                    bathrooms: 2,
                    kitchens: 1,
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
