// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:kiwihabitapp/auth/authFunctions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static const _bg = Color.fromRGBO(21, 9, 35, 1);
  static const _cream = Color(0xffE4EBDE);
  static const _purple = Color(0xff6C3FC5);

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final name = _userNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters.');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final error = await AuthService().createUserWithEmail(email, password, name);
      if (mounted) {
        if (error != null) {
          setState(() { _isLoading = false; _errorMessage = error; });
        } else {
          // Auth state change will update CheckAuth → HomePage
          // Pop to root so the new HomePage is visible
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() { _isLoading = false; _errorMessage = 'Something went wrong. Please try again.'; });
      }
    }
  }

  InputDecoration _fieldDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.publicSans(color: Colors.grey.shade500),
      filled: true,
      fillColor: _cream,
      prefixIcon: Icon(icon, color: _purple),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _cream),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create Account', style: GoogleFonts.publicSans(color: _cream, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/json/loading.json', width: 120),
                    SizedBox(height: 16),
                    Text('Creating your account...', style: GoogleFonts.publicSans(color: _cream, fontSize: 16)),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Join the challenge!',
                      style: GoogleFonts.publicSans(
                        color: _cream,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create your account and start your first challenge today.',
                      style: GoogleFonts.publicSans(color: _cream.withOpacity(0.6), fontSize: 14),
                    ),
                    SizedBox(height: 32),

                    // Username
                    TextFormField(
                      controller: _userNameController,
                      style: GoogleFonts.publicSans(color: Color(0xff150923), fontSize: 15),
                      decoration: _fieldDecoration('Username', Icons.person_outline),
                    ),
                    SizedBox(height: 14),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.publicSans(color: Color(0xff150923), fontSize: 15),
                      decoration: _fieldDecoration('Email', Icons.email_outlined),
                    ),
                    SizedBox(height: 14),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.publicSans(color: Color(0xff150923), fontSize: 15),
                      decoration: _fieldDecoration('Password', Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey.shade500),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      style: GoogleFonts.publicSans(color: Color(0xff150923), fontSize: 15),
                      decoration: _fieldDecoration('Confirm Password', Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey.shade500),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      onFieldSubmitted: (_) => _signUp(),
                    ),

                    if (_errorMessage != null) ...[
                      SizedBox(height: 12),
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

                    SizedBox(height: 28),

                    ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: _cream,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Create Account',
                        style: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1),
                      ),
                    ),

                    SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.publicSans(color: _cream.withOpacity(0.6), fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.publicSans(
                              color: Color(0xff9B6AE8),
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
      ),
    );
  }
}
