import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'home_screen.dart'; 
import 'forgot_password_screen.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                image: AssetImage('images/4.jpg'),
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
                colors: [Colors.black26, Colors.black],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    const Icon(Icons.restaurant_menu, size: 100, color: Colors.orange),
                    const SizedBox(height: 20),
                    const Text(
                      "أهلاً بك",
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "سجل دخولك لبدء رحلة الطهي",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 60),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white12,
                        hintText: "البريد الإلكتروني",
                        hintStyle: const TextStyle(color: Colors.white60),
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.orange),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white12,
                        hintText: "كلمة المرور",
                        hintStyle: const TextStyle(color: Colors.white60),
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.orange),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                        },
                        child: const Text("نسيت كلمة المرور؟", style: TextStyle(color: Colors.orange)),
                      ),
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
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                        },
                        child: const Text("دخول", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white24, endIndent: 10)),
                        Text("أو سجل باستخدام", style: TextStyle(color: Colors.white60)),
                        Expanded(child: Divider(color: Colors.white24, indent: 10)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white70),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.white),
                        label: const Text("حساب Google", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("ليس لديك حساب؟", style: TextStyle(color: Colors.white70)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                          },
                          child: const Text("إنشاء حساب", style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}