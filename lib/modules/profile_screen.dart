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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Row : Image & Name & Gmail
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/images/mounir.jpg"),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mouniro",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Mouniro@gmail.com",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),

            // Message & Schedule & Call
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    icon: Icons.message_rounded,
                    color: Colors.blue,
                    label: "Message",
                    onTap: () => print("Message"),
                  ),
                  _buildActionButton(
                    icon: Icons.calendar_month,
                    color: Colors.orange,
                    label: "Schedule",
                    onTap: () => print("Schedule"),
                  ),
                  _buildActionButton(
                    icon: Icons.call,
                    color: Colors.green,
                    label: "Call",
                    onTap: () => print("Call"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Property Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Property",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Poppins montserrat',
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Property List
            // In your ListView.builder or anywhere else:
            PropertyCard(
              imageUrl: 'https://example.com/property1.jpg',
              name: 'Luxury Villa',
              price: 2500.00,
              address: '123 Palm Street, Miami, FL',
              size: 1800,
              bedrooms: 3,
              bathrooms: 2,
              kitchens: 1,
            ),
            PropertyCard(
              imageUrl: 'https://example.com/property1.jpg',
              name: 'Luxury Villa',
              price: 2500.00,
              address: '123 Palm Street, Miami, FL',
              size: 1800,
              bedrooms: 3,
              bathrooms: 2,
              kitchens: 1,
            ),
            PropertyCard(
              imageUrl: 'https://example.com/property1.jpg',
              name: 'Luxury Villa',
              price: 2500.00,
              address: '123 Palm Street, Miami, FL',
              size: 1800,
              bedrooms: 3,
              bathrooms: 2,
              kitchens: 1,
            ),
            PropertyCard(
              imageUrl: 'https://example.com/property1.jpg',
              name: 'Luxury Villa',
              price: 2500.00,
              address: '123 Palm Street, Miami, FL',
              size: 1800,
              bedrooms: 3,
              bathrooms: 2,
              kitchens: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final String address;
  final double size;
  final int bedrooms;
  final int bathrooms;
  final int kitchens;

  const PropertyCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.address,
    required this.size,
    required this.bedrooms,
    required this.bathrooms,
    required this.kitchens,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade200.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Row(
        children: [
          // Property Image
          Container(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Image.asset(
                'assets/images/building.jpg',
                fit: BoxFit.cover,
                width: 100,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Ensures proper spacing
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // Prevents overflow
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Adds space between name and price
                      Text(
                        '\$${price.toStringAsFixed(2)}/mo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        address,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Property Features
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFeatureItem(Icons.aspect_ratio,
                          '${size.toStringAsFixed(0)} sqft'),
                      _buildFeatureItem(Icons.king_bed, '$bedrooms'),
                      _buildFeatureItem(Icons.bathtub, '$bathrooms'),
                      _buildFeatureItem(Icons.kitchen, '$kitchens'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.orange),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
      ],
    );
  }
}
