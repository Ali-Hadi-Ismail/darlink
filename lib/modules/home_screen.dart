import 'package:darlink/constants/colors/app_color.dart';
import 'package:darlink/modules/profile_screen.dart';
import 'package:darlink/shared/widgets/filter_bottom.dart';
import 'package:darlink/shared/widgets/propertyCard.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RangeValues sizeRange = const RangeValues(0, 10000);
  RangeValues priceRange = const RangeValues(0, 30000);

  @override
  Widget build(BuildContext context) {
    void _showFilterBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1F33),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Property types',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Property Size',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Up to ${sizeRange.end.toInt()} sqft',
                                style: TextStyle(
                                  color: Colors.cyan.shade300,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderThemeData(
                              thumbColor: Colors.cyan.shade300,
                              activeTrackColor: Colors.cyan.shade300,
                              inactiveTrackColor: Colors.grey.shade800,
                            ),
                            child: RangeSlider(
                              values: sizeRange,
                              min: 0,
                              max: 10000,
                              onChanged: (RangeValues values) {
                                setModalState(() {
                                  sizeRange = values;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Property Price',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Low',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'High',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderThemeData(
                              thumbColor: Colors.cyan.shade300,
                              activeTrackColor: Colors.cyan.shade300,
                              inactiveTrackColor: Colors.grey.shade800,
                            ),
                            child: RangeSlider(
                              values: priceRange,
                              min: 0,
                              max: 30000,
                              onChanged: (RangeValues values) {
                                setModalState(() {
                                  priceRange = values;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${priceRange.start.toInt()}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${priceRange.end.toInt()}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                // Reset logic would go here
                                setModalState(() {
                                  sizeRange = const RangeValues(0, 10000);
                                  priceRange = const RangeValues(0, 30000);
                                });
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.indigo.shade300),
                                ),
                                child: Center(
                                  child: Text(
                                    'Reset',
                                    style: TextStyle(
                                      color: Colors.indigo.shade300,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () {
                                // Apply filter logic would go here
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5D5FEF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Check availability',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      bottomSheet: const FilterBottomSheet(),
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          "Home Screen",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: const CircleAvatar(
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
                    _showFilterBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Purple background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list, color: Colors.white),
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
                children: const [
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
