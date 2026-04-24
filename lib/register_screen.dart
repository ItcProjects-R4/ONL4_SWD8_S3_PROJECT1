import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
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
              image: DecorationImage(image: AssetImage('images/5.jpg'), fit: BoxFit.cover),
            ),
          ),
          Container(
            height: double.infinity, width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
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
                      const Text("إنشاء حساب", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                      const Text("انضم إلينا وابدأ مغامرة الطهي", style: TextStyle(fontSize: 18, color: Colors.white70)),
                      const SizedBox(height: 60),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("البريد الإلكتروني", Icons.email_outlined),
                        validator: (value) => (value == null || !value.contains('@')) ? 'يرجى إدخال بريد إلكتروني صحيح' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passController,
                        obscureText: _isObscure,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("كلمة المرور", Icons.lock_outline, isPassword: true),
                        validator: (value) => (value != null && value.length < 8) ? 'كلمة المرور يجب أن تكون 8 أحرف على الأقل' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPassController,
                        obscureText: _isObscure,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("تأكيد كلمة المرور", Icons.lock_reset, isPassword: true),
                        validator: (value) => (value != _passController.text) ? 'كلمة المرور غير متطابقة' : null,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity, height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: isLoading ? null : _register,
                          child: isLoading 
                              ? const CircularProgressIndicator(color: Colors.white) 
                              : const Text("إنشاء الحساب", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("لديك حساب بالفعل؟", style: TextStyle(color: Colors.white70)),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
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
Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        // استخدام FirebaseAuth مباشرة زي ما إنتِ عاملة في الكود
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );
        
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم إنشاء الحساب بنجاح، يرجى تسجيل الدخول")),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        
      } on FirebaseAuthException catch (e) {
        String message = 'حدث خطأ ما';
        if (e.code == 'email-already-in-use') message = 'هذا البريد مستخدم بالفعل';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      } finally {
        if (mounted) setState(() => isLoading = false);
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