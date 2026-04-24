import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'home_screen.dart'; 
import 'forgot_password_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity, width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('images/4.jpg'), fit: BoxFit.cover),
            ),
          ),
          Container(
            height: double.infinity, width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.black],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Icon(Icons.restaurant_menu, size: 100, color: Colors.orange),
                      const SizedBox(height: 20),
                      const Text("أهلاً بك", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 60),
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("البريد الإلكتروني", Icons.email_outlined),
                        validator: (value) => (value == null || !value.contains('@')) ? 'بريد غير صحيح' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _isObscure,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("كلمة المرور", Icons.lock_outline, isPassword: true),
                        validator: (value) => (value == null || value.isEmpty) ? 'أدخل كلمة المرور' : null,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
                          child: const Text("نسيت كلمة المرور؟", style: TextStyle(color: Colors.orange)),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity, height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: isLoading ? null : _login,
                          child: isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("دخول", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("ليس لديك حساب؟", style: TextStyle(color: Colors.white70)),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                            child: const Text("إنشاء حساب", style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ في الدخول")));
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon, {bool isPassword = false}) {
    return InputDecoration(
      filled: true, fillColor: Colors.white12,
      hintText: hint, hintStyle: const TextStyle(color: Colors.white60),
      prefixIcon: Icon(icon, color: Colors.orange),
      suffixIcon: isPassword ? IconButton(
        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off, color: Colors.orange),
        onPressed: () => setState(() => _isObscure = !_isObscure),
      ) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    );
  }
}