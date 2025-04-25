import 'package:darlink/shared/widgets/propertyCard.dart';
import 'package:flutter/material.dart';
import 'package:darlink/constants/colors/app_color.dart';

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
