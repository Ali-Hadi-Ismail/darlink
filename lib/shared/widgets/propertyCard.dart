import 'package:flutter/material.dart';

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
                imageUrl,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),

          // Property Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${price.toStringAsFixed(2)}/mo',
                        style: const TextStyle(
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
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        address,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                            overflow: TextOverflow.fade),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
