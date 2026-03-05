// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';
import 'package:kiwihabitapp/pages/auth/signUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);
  static const _purple = Color(0xff6C3FC5);
  static const _purpleLight = Color(0xff9B6AE8);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter email and password.');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = null; });
    final error = await AuthService().signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (mounted) {
      setState(() { _isLoading = false; _errorMessage = error; });
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    final error = await AuthService().signInWithGoogle();
    if (mounted && error != null && error != 'cancelled') {
      setState(() { _isLoading = false; _errorMessage = error; });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithApple() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    final error = await AuthService().signInWithApple();
    if (mounted && error != null) {
      setState(() { _isLoading = false; _errorMessage = error; });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/json/loading.json', width: 120),
                    SizedBox(height: 16),
                    Text('Signing in...', style: GoogleFonts.publicSans(color: _cream, fontSize: 16)),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // ── Header ────────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff2D1B69),
                            Color(0xff6C3FC5),
                            Color(0xff150923),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/json/exercise.json', width: 100, height: 100),
                          SizedBox(height: 8),
                          Text(
                            'Volt',
                            style: GoogleFonts.publicSans(
                              color: _cream,
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                            ),
                          ),
                          Text(
                            'Challenge Yourself Together',
                            style: GoogleFonts.publicSans(
                              color: _cream.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Login Form ────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome back',
                            style: GoogleFonts.publicSans(
                              color: _cream,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Sign in to continue your challenges',
                            style: GoogleFonts.publicSans(
                              color: _cream.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 28),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.publicSans(color: Color(0xff150923), fontSize: 15),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: GoogleFonts.publicSans(color: Colors.grey.shade500),
                              filled: true,
                              fillColor: _cream,
                              prefixIcon: Icon(Icons.email_outlined, color: _purple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                          ),
                          SizedBox(height: 14),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.publicSans(color: Color(0xff150923), fontSize: 15),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: GoogleFonts.publicSans(color: Colors.grey.shade500),
                              filled: true,
                              fillColor: _cream,
                              prefixIcon: Icon(Icons.lock_outline, color: _purple),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: Colors.grey.shade500,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            onFieldSubmitted: (_) => _loginWithEmail(),
                          ),

                          // Error message
                          if (_errorMessage != null) ...[
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade900.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade400, width: 0.5),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: GoogleFonts.publicSans(color: Colors.red.shade300, fontSize: 13),
                              ),
                            ),
                          ],

                          SizedBox(height: 20),

                          // Sign In button
                          ElevatedButton(
                            onPressed: _loginWithEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _purple,
                              foregroundColor: _cream,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.publicSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: _cream.withOpacity(0.2))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'or continue with',
                                  style: GoogleFonts.publicSans(color: _cream.withOpacity(0.5), fontSize: 12),
                                ),
                              ),
                              Expanded(child: Divider(color: _cream.withOpacity(0.2))),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Google button
                          _SocialButton(
                            label: 'Continue with Google',
                            iconPath: 'assets/images/Google.png',
                            onTap: _loginWithGoogle,
                            bg: Color(0xff1E1432),
                            textColor: _cream,
                          ),

                          // Apple button (iOS only)
                          if (Platform.isIOS) ...[
                            SizedBox(height: 12),
                            _SocialButton(
                              label: 'Continue with Apple',
                              iconPath: 'assets/images/Apple.png',
                              onTap: _loginWithApple,
                              bg: Colors.white,
                              textColor: Colors.black,
                            ),
                          ],

                          SizedBox(height: 32),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.publicSans(color: _cream.withOpacity(0.6), fontSize: 14),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => SignUpPage()),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.publicSans(
                                    color: _purpleLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;
  final Color bg;
  final Color textColor;

  const _SocialButton({
    required this.label,
    required this.iconPath,
    required this.onTap,
    required this.bg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 22, height: 22),
            SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.publicSans(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
