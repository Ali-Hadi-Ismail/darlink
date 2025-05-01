import 'package:darlink/constants/colors/app_color.dart';
import 'package:darlink/shared/widgets/card/propertyCard.dart';
import 'package:flutter/material.dart';
import 'package:darlink/models/property.dart';
import 'package:darlink/modules/navigation/profile_screen.dart';
import 'package:darlink/shared/widgets/filter_bottom.dart';
import 'package:fixnum/fixnum.dart';
import '../../constants/Database_url.dart' as mg;

int id = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Property? property; // To hold fetched property data
  bool isLoading = false; // To show loading indicator if needed

  @override
  void initState() {
    super.initState();
    /* _fetchProperty(); */
  }

/*   Future<void> _fetchProperty() async {
    final proprty_info = await mg.collect_info_properties(id);
    id++;
    if (proprty_info != null) {
      setState(() {
        property = Property(
          title: proprty_info['Title'] as String,
          price: proprty_info['price'] as double,
          address: "database akal",
          area: (proprty_info['area']as Int64).toInt() ,
          bedrooms: (proprty_info['bathrooms'] as Int64).toInt(),
          bathrooms: (proprty_info['bathrooms'] as Int64).toInt(),
          kitchens: 1,
          ownerName: proprty_info['ownerName'] as String,
          imageUrl: "assets/images/building.jpg",
          amenities: ["swim pool", "led light"],
          interiorDetails: ["white floor"],
        );
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false; // Handle null or error case
      });
    }
  } */

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(
            "Find Properties",
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/mounir.jpg"),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Use a default property if the fetched data is null
    final Property displayProperty = property ??
        Property(
          title: "Sample Property",
          price: 100000,
          address: "Bshamoun",
          area: 120,
          bedrooms: 3,
          bathrooms: 2,
          kitchens: 1,
          ownerName: "Owner Name",
          imageUrl: "assets/images/building.jpg",
          amenities: ["swim pool", "led light"],
          interiorDetails: ["white floor"],
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          "Find Properties",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
                backgroundColor: Colors.white,
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
                        color: Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Button
                ElevatedButton(
                  onPressed: () => showFilterBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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
                          color: Colors.white,
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
                _buildPropertyCard(context, property: displayProperty),
                const SizedBox(height: 16),
                _buildPropertyCard(context, property: displayProperty),
                const SizedBox(height: 16),
                _buildPropertyCard(context, property: displayProperty),
                const SizedBox(height: 16),
                _buildPropertyCard(context, property: displayProperty),
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
