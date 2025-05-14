import 'package:darlink/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:darlink/constants/colors/app_color.dart';

// Profile Screen (updated to handle edits)
class ProfileUserScreen extends StatefulWidget {
  final User user;
  final Function(User) onProfileUpdated;

  const ProfileUserScreen({
    super.key,
    required this.user,
    required this.onProfileUpdated,
  });

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  void _navigateToEditScreen() async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: currentUser),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        currentUser = updatedUser;
      });
      widget.onProfileUpdated(updatedUser);
    }
  }

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
            Navigator.pop(context, currentUser);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditScreen,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ... (rest of your existing profile screen UI)
            // Keep all the same UI elements but use currentUser instead of widget.user
          ],
        ),
      ),
    );
  }
}

// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);

    _selectedAvatarPath = widget.user.avatarUrl;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    // Implement image picking logic here
    // For example using image_picker package:
    // final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     _selectedAvatarPath = pickedFile.path;
    //   });
    // }
  }

  void _saveChanges() {
    final updatedUser = widget.user.copyWith(
      name: _usernameController.text,
      email: _emailController.text,
      avatarUrl: _selectedAvatarPath,
    );

    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Edit Profile',
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'Save',
              style: textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      backgroundImage: _selectedAvatarPath?.isNotEmpty == true
                          ? NetworkImage(_selectedAvatarPath!)
                          : const AssetImage("assets/images/default_avatar.png")
                              as ImageProvider,
                      child: _selectedAvatarPath?.isEmpty ?? true
                          ? Text(
                              _usernameController.text.isNotEmpty
                                  ? _usernameController.text
                                      .substring(0, 1)
                                      .toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildEditField(
              controller: _usernameController,
              icon: Icons.person,
              label: 'Username',
              hintText: 'Enter your username',
            ),
            const SizedBox(height: 20),
            _buildEditField(
              controller: _emailController,
              icon: Icons.email,
              label: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildEditField(
              /// put here the phone number field remove email
              controller: _emailController,
              icon: Icons.phone,
              label: 'Phone Number',
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
