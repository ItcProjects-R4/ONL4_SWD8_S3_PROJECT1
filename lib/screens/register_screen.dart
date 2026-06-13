import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = await _authService.registerWithEmail(
      _emailController.text.trim(),
      _passController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تم إنشاء الحساب بنجاح، يرجى تسجيل الدخول",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.surface,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "حدث خطأ، تأكد من البيانات وحاول مرة أخرى",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.surface,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/sin (1).jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.65),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/sin (2).jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Create Account",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Join us and start your cooking journey",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      hint: "Email",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      validator: (v) =>
                          (v == null || !v.contains('@'))
                              ? 'Invalid email'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      hint: "Password",
                      icon: Icons.lock_outline,
                      controller: _passController,
                      isPassword: true,
                      obscure: _isObscure,
                      onToggleObscure: () =>
                          setState(() => _isObscure = !_isObscure),
                      validator: (v) =>
                          (v != null && v.length < 6)
                              ? 'Min 6 characters'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      hint: "Confirm Password",
                      icon: Icons.lock_reset,
                      controller: _confirmPassController,
                      isPassword: true,
                      obscure: _isConfirmObscure,
                      onToggleObscure: () => setState(
                        () => _isConfirmObscure = !_isConfirmObscure,
                      ),
                      validator: (v) =>
                          (v != _passController.text)
                              ? 'Passwords do not match'
                              : null,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 98, 40, 2),
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Sign Up"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
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

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color.fromARGB(201, 255, 255, 255)),
          prefixIcon: Icon(icon, color: Colors.orange),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onToggleObscure,
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color.fromARGB(191, 255, 255, 255),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}