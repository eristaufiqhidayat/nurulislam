// ignore_for_file: library_private_types_in_public_api, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurulislam/pages/forgot_password_page.dart';
import 'package:nurulislam/pages/register/otp_dialog.dart';
import 'package:nurulislam/screens/home_screen.dart';
import 'package:nurulislam/widgets/menu_drawer.dart';
import '../services/auth_service.dart';
//import '../models/user_model.dart';
import '../utils/shared_prefs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final savedUser = await SharedPrefs.getUser();

    if (savedUser != null) {
      setState(() {
        _emailController.text = savedUser.email;
      });
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    //print('Attempting login for: ${_emailController.text}');
    try {
      final user = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      await SharedPrefs.saveUser(user!);
      if (user.message != null && user.message!.isNotEmpty) {
        throw Exception(user.message);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Login gagal: Cek email dan password Anda'),
              backgroundColor: Colors.red),
        );
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e}'), backgroundColor: Colors.red),
        );
      }
      if (e.toString().contains('verifikasi')) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => OtpDialog(email: _emailController.text),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: MobileAppBar(judul: 'Login'),
        endDrawer: MobileDrawer(),
        backgroundColor: Colors.grey[100],
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              //width: MediaQuery.of(context).size.width * 0.7,
              width: 350,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green, // Warna border hijau
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo/Image
                  // Ganti bagian logo/image di dalam Column
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[100], // hijau muda
                      border: Border.all(color: Colors.green, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(100), // bikin gambar bundar
                      child: Image.asset(
                        'assets/images/masjid.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover, // biar gambar pas di dalam lingkaran
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Title
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Email Field
                  TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.green),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ))),
                  SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Login Button
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _login,
                            child: Text(
                              'MASUK',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                  SizedBox(height: 16),

                  // Forgot Password
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text(
                          'Lupa Password?',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Register?',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
