import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import 'menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Orange-brown color matching the design (#D9572CCC with alpha)
  static const Color _accentColor = Color(0xCCD9572C); // Orange-brown with alpha

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locale = Localizations.localeOf(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isEnglish = locale.languageCode == 'en';

    return Scaffold(
      backgroundColor: Colors.white, // Full page white background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.18), // 1. Increased space above Wabisabi
                      // Wabisabi title
                      Text(
                        'Wabisabi',
                        style: GoogleFonts.inter(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          color: _accentColor,
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8), // 2. Decreased space between Wabisabi and Log in
                      // Log in subtitle
                      Text(
                        'Log in',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 100), // Increased space after Log in text
                      // Email Address input
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email Address',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'mail@example.com',
                          hintStyle: GoogleFonts.inter(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: _accentColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16), // 6. Decreased space between Email input and Password label
                      // Password input
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4), // 7. Decreased space between Password label and input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: _accentColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8), // 8. Decreased space between Password input and Forgot Password
                      // Forgot Password link
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password functionality
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: _accentColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Find a restaurant button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // TODO: Implement login functionality
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MenuPage()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Find a restaurant',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Sign up link
                      TextButton(
                        onPressed: () {
                          // TODO: Implement sign up navigation
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign up',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: _accentColor,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.2), // 9. Push language selector to very bottom
                      // Language selector at bottom: JP | EN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              localeProvider.setLocale(const Locale('ja'));
                            },
                            child: Text(
                              'JP',
                              style: TextStyle(
                                fontFamily: 'Noto Sans JP',
                                fontSize: 20,
                                fontWeight: !isEnglish 
                                    ? FontWeight.bold 
                                    : FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                height: 1.0, // 100% line-height
                                letterSpacing: 1.0, // 5% of 20px = 1.0
                                color: !isEnglish ? Colors.black : Colors.grey.shade600,
                                decoration: !isEnglish 
                                    ? TextDecoration.underline 
                                    : TextDecoration.none,
                                decorationThickness: 2.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '|',
                              style: TextStyle(
                                fontFamily: 'Noto Sans JP',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              localeProvider.setLocale(const Locale('en'));
                            },
                            child: Text(
                              'EN',
                              style: TextStyle(
                                fontFamily: 'Noto Sans JP',
                                fontSize: 20,
                                fontWeight: isEnglish 
                                    ? FontWeight.bold 
                                    : FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                height: 1.0, // 100% line-height
                                letterSpacing: 1.0, // 5% of 20px = 1.0
                                color: isEnglish ? Colors.black : Colors.grey.shade600,
                                decoration: isEnglish 
                                    ? TextDecoration.underline 
                                    : TextDecoration.none,
                                decorationThickness: 2.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.05), // Bottom padding
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
