import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black12, Colors.black],
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
                      const Icon(Icons.person_add_alt_1, size: 100, color: Colors.orange),
                      const SizedBox(height: 20),
                      const Text(
                        "إنشاء حساب",
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "انضم إلينا وابدأ مغامرة الطهي",
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                      const SizedBox(height: 60),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("الاسم الكامل", Icons.person_outline),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الاسم';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("البريد الإلكتروني", Icons.email_outlined),
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'يرجى إدخال بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("كلمة المرور", Icons.lock_outline),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPassController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("تأكيد كلمة المرور", Icons.lock_reset),
                        validator: (value) {
                          if (value != _passController.text) {
                            return 'كلمة المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            }
                          },
                          child: const Text("إنشاء الحساب", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("لديك حساب بالفعل؟", style: TextStyle(color: Colors.white70)),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                            },
                            child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
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

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white12,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white60),
      prefixIcon: Icon(icon, color: Colors.orange),
      errorStyle: const TextStyle(color: Colors.redAccent),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.orange)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.redAccent)),
    );
  }
}