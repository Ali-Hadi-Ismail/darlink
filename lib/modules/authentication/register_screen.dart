import 'dart:developer';

import 'package:darlink/modules/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../../constants/database_url.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _usernameError;
  String? _emailError;
  String? _passwordError;

  bool _hasStartedTypingUsername = false;
  bool _hasStartedTypingEmail = false;
  bool _hasStartedTypingPassword = false;
  bool exists_name = false;
  bool exists_email = false;

  Future<void> _validateAndRegister() async {
    exists_name = false;
    exists_email = false;

    var db = await mongo.Db.create(mongo_url);
    await db.open();
    inspect(db);
    var collection = db.collection("user");

    final result_name = await collection
        .findOne(mongo.where.eq("name", _usernameController.text));
    if (result_name != null) {
      exists_name = true;
    }

    final result_email = await collection
        .findOne(mongo.where.eq("Email", _emailController.text));
    if (result_email != null) {
      exists_email = true;
    }

    setState(() {
      if (_usernameController.text.isEmpty) {
        _usernameError = 'Username cannot be empty';
      } else if (exists_name == true) {
        _usernameError = 'Username already exists';
      } else if (_usernameController.text.length < 6) {
        _usernameError = 'Username must be at least 6 characters';
      } else {
        _usernameError = null;
      }

      if (_emailController.text.isEmpty) {
        _emailError = 'Email cannot be empty';
      } else if (exists_email == true) {
        _emailError = 'Email already exists';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
          .hasMatch(_emailController.text)) {
        // Check if email is valid
        _emailError = 'Enter a valid email';
      } else {
        // Valid email, no error
        _emailError = null;
      }

      _passwordError =
          _passwordController.text.isEmpty ? 'Password cannot be empty' : null;
    });

    if (_usernameError == null &&
        _emailError == null &&
        _passwordError == null) {
      print("Registration Successful");
      await collection.insertOne({
        "name": _usernameController.text,
        "Password": _passwordController.text,
        "Email": _emailController.text
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C44EB),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Color(0xFF1C1D39),
        ),
        margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.2),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Username Field
              _buildTextField(
                controller: _usernameController,
                label: 'Username',
                icon: FontAwesomeIcons.user,
                iconColor: Colors.orange,
                hintText: 'Enter your username',
                errorText: _hasStartedTypingUsername ? _usernameError : null,
                onChanged: (value) {
                  setState(() {
                    _hasStartedTypingUsername = true;
                    if (_usernameController.text.isEmpty) {
                      _usernameError = 'Username cannot be empty';
                    } else if (exists_name == true) {
                      _usernameError = 'Username already exists';
                    } else if (_usernameController.text.length < 6) {
                      _usernameError = 'Username must be at least 6 characters';
                    } else {
                      _usernameError = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 15),

              // Email Field
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: FontAwesomeIcons.envelope,
                iconColor: Colors.green,
                hintText: 'Enter your email',
                errorText: _hasStartedTypingEmail ? _emailError : null,
                onChanged: (value) {
                  setState(() {
                    _hasStartedTypingEmail = true;
                    if (_emailController.text.isEmpty) {
                      _emailError = 'Email cannot be empty';
                    } else if (exists_email == true) {
                      _emailError = 'Email already exists';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(_emailController.text)) {
                      // Check if email is valid
                      _emailError = 'Enter a valid email';
                    } else {
                      // Valid email, no error
                      _emailError = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 15),

              // Password Field
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: FontAwesomeIcons.lock,
                iconColor: Colors.purple,
                hintText: 'Enter your password',
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                errorText: _hasStartedTypingPassword ? _passwordError : null,
                onChanged: (value) {
                  setState(() {
                    _hasStartedTypingPassword = true;
                    _passwordError =
                        value.isEmpty ? 'Password cannot be empty' : null;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Register Button
              ElevatedButton(
                onPressed: _validateAndRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Social Media Buttons
              const Text(
                'Or register with',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    icon: FontAwesomeIcons.facebookF,
                    color: Colors.blue,
                    onTap: () => print('Facebook Login'),
                  ),
                  _buildSocialButton(
                    icon: FontAwesomeIcons.google,
                    color: Colors.red,
                    onTap: () => print('Google Login'),
                  ),
                  _buildSocialButton(
                    icon: FontAwesomeIcons.envelope,
                    color: Colors.green,
                    onTap: () => print('Gmail Login'),
                  ),
                  _buildSocialButton(
                    icon: FontAwesomeIcons.apple,
                    color: Colors.black,
                    onTap: () => print('Apple Login'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Login Text
              GestureDetector(
                onTap: () {
                  // Navigate to Login Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color iconColor,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    String? errorText,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: errorText != null ? Colors.red : Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFF2C2D49),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.3),
            child: FaIcon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
        ),
        suffixIcon: suffixIcon,
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.purpleAccent,
            width: 2,
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 30, // Larger background circle
        backgroundColor: color.withOpacity(0.2),
        child: FaIcon(icon, color: color, size: 24),
      ),
    );
  }
}
