import 'package:darlink/layout/home_layout.dart';
import 'package:darlink/models/property.dart';
import 'package:darlink/models/user_model.dart';
import 'package:darlink/modules/edit_profile.dart';
import 'package:darlink/shared/widgets/card/propertyCard.dart';
import 'package:flutter/material.dart';
import 'package:darlink/constants/colors/app_color.dart';

class ProfileUserScreen extends StatelessWidget {
  final User user;

  const ProfileUserScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'My Profile',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeLayout(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: user),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Profile Picture and Basic Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: user.avatarUrl.isNotEmpty
                      ? NetworkImage(user.avatarUrl)
                      : const AssetImage("assets/images/default_avatar.png")
                          as ImageProvider,
                  child: user.avatarUrl.isEmpty
                      ? Text(
                          user.username.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  user.username,
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Member since ${user.joinDate}",
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // User Details Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailCard(
                  icon: Icons.person,
                  title: "Username",
                  value: user.username,
                ),
                const SizedBox(height: 15),
                _buildDetailCard(
                  icon: Icons.email,
                  title: "Email",
                  value: user.email,
                ),
                const SizedBox(height: 15),
                //do it for phone here
                _buildDetailCard(
                  icon: Icons.phone,
                  title: "Email",
                  value: user.email ??
                      "Not provided", // Assuming phone is optional
                ),
                const SizedBox(height: 15),
                _buildDetailCard(
                  icon: Icons.verified_user,
                  title: "Role",
                  value: user.role,
                ),
              ],
            ),
          ),

          // Properties Section
          /*  if (user.properties.isNotEmpty) // Only show if user has properties
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Properties",
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Property List
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: user..length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: PropertyCard(property: user.properties[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ], */
        ]),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
