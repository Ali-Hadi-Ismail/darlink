import 'dart:developer';

import 'package:darlink/modules/authentication/forget_password.dart';
import 'package:darlink/modules/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../../constants/database_url.dart';
import '../../constants/colors/app_color.dart';
import 'package:email_otp/email_otp.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _otpSent = false;
  String? _otpError;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? _usernameError;
  String? _emailError;

  bool _hasStartedTypingUsername = false;
  bool _hasStartedTypingEmail = false;
  bool _userExists = false;

  EmailOTP myauth = EmailOTP();

  @override
  void initState() {
    super.initState();
    // Configure EmailOTP
    EmailOTP.config(
      appName: 'Darlink',
      otpType: OTPType.numeric,
      emailTheme: EmailTheme.v3,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Validate email format
  bool _isValidEmailFormat(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Check if user exists in database
  Future<bool> _checkUserExists() async {
    if (_emailController.text.isEmpty || _usernameController.text.isEmpty) {
      return false;
    }

    try {
      // Connect to the database
      var db = await mongo.Db.create(mongo_url);
      await db.open();
      inspect(db);
      var collection = db.collection('user');

      // Check if the user exists with the provided email and username
      final user = await collection.findOne(
        mongo.where
            .eq('Email', _emailController.text)
            .eq('name', _usernameController.text),
      );

      // Close database connection
      await db.close();

      return user != null;
    } catch (e) {
      print("Database error: $e");
      return false;
    }
  }

  Future<void> _sendOTP() async {
    if (_emailError != null ||
        _emailController.text.isEmpty ||
        _usernameError != null ||
        _usernameController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // First check if user exists in database
    _userExists = await _checkUserExists();

    if (!_userExists) {
      setState(() {
        _isLoading = false;
        _emailError = 'No account found with this email and username';
      });
      return;
    }

    // Send OTP
    bool result = await EmailOTP.sendOTP(
      email: _emailController.text,
    );

    setState(() {
      _otpSent = result;
      _isLoading = false;
    });

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send verification code')),
      );
    }
  }

  Future<void> _verifyAndProceed() async {
    // Check if OTP is valid
    if (_otpController.text.isEmpty) {
      setState(() {
        _otpError = 'Please enter verification code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool isVerified = EmailOTP.verifyOTP(otp: _otpController.text);

    if (!isVerified) {
      setState(() {
        _isLoading = false;
        _otpError = 'Invalid verification code';
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });

    // If verification is successful, navigate to forgot password screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordWithEmail(
            email: _emailController.text,
            username: _usernameController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final primaryColor = colorScheme.primary;
    final surfaceColor =
        isDarkMode ? AppColors.backgroundDark : colorScheme.surface;
    final onSurfaceColor =
        isDarkMode ? AppColors.textOnDark : colorScheme.onSurface;
    final secondaryColor = AppColors.secondary;

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: surfaceColor,
        ),
        margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.2),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Verify Email',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter your username and email to verify your identity',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurfaceColor.withOpacity(0.7),
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
                  iconColor: Colors.deepPurple,
                  hintText: 'Enter your username',
                  errorText: _hasStartedTypingUsername ? _usernameError : null,
                  onChanged: (value) {
                    setState(() {
                      _hasStartedTypingUsername = true;

                      if (value.isEmpty) {
                        _usernameError = 'Username cannot be empty';
                      } else if (value.length < 6) {
                        _usernameError =
                            'Username must be at least 6 characters';
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
                  keyboardType: TextInputType.emailAddress,
                  icon: FontAwesomeIcons.envelope,
                  iconColor: Colors.blue,
                  hintText: 'Enter your email',
                  errorText: _hasStartedTypingEmail ? _emailError : null,
                  onChanged: (value) {
                    setState(() {
                      _hasStartedTypingEmail = true;

                      if (value.isEmpty) {
                        _emailError = 'Email cannot be empty';
                      } else if (!_isValidEmailFormat(value)) {
                        _emailError = 'Enter a valid email';
                      } else {
                        _emailError = null;
                      }
                    });
                  },
                  suffixIcon: !_otpSent
                      ? TextButton(
                          onPressed: _emailError == null &&
                                  _emailController.text.isNotEmpty &&
                                  _usernameError == null &&
                                  _usernameController.text.isNotEmpty &&
                                  !_isLoading
                              ? _sendOTP
                              : null,
                          child: _isLoading && !_otpSent
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: onSurfaceColor,
                                  ),
                                )
                              : Text(
                                  'Send Code',
                                  style: TextStyle(color: secondaryColor),
                                ),
                        )
                      : Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                ),
                const SizedBox(height: 15),

                // OTP Field (only shown after OTP is sent)
                if (_otpSent)
                  Column(
                    children: [
                      _buildTextField(
                        controller: _otpController,
                        label: 'Verification Code',
                        icon: FontAwesomeIcons.key,
                        iconColor: Colors.green,
                        hintText: 'Enter verification code',
                        keyboardType: TextInputType.number,
                        errorText: _otpError,
                        onChanged: (value) {
                          setState(() {
                            _otpError = null;
                          });
                        },
                      ),
                      const SizedBox(height: 30),

                      // Verify Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _verifyAndProceed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: onSurfaceColor,
                                ),
                              )
                            : Text(
                                'Verify & Continue',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                      ),
                    ],
                  ),

                // Navigation Options
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                  child: RichText(
                    text: TextSpan(
                      text: "Remember your password? ",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: onSurfaceColor.withOpacity(0.8),
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: secondaryColor,
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
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? errorText,
    required Function(String) onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // Consistent field colors based on theme
    final fieldBackgroundColor = isDarkMode
        ? colorScheme.surface.withOpacity(0.1)
        : colorScheme.primary.withOpacity(0.1);

    final textColor = isDarkMode ? AppColors.textOnDark : colorScheme.onSurface;

    final labelColor = errorText != null
        ? colorScheme.error
        : (isDarkMode ? AppColors.textOnDark : colorScheme.onSurface);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      autocorrect: false,
      autofocus: false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: labelColor,
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: textColor.withOpacity(0.5),
          fontSize: 14,
        ),
        filled: true,
        fillColor: fieldBackgroundColor,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: FaIcon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
        ),
        suffixIcon: suffixIcon,
        alignLabelWithHint: true,
        errorText: errorText,
        errorStyle: TextStyle(
          color: colorScheme.error,
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: errorText != null ? colorScheme.error : colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
      ),
      style: TextStyle(
        color: textColor,
        fontSize: 16,
        fontFamily: 'Poppins',
      ),
    );
  }
}
