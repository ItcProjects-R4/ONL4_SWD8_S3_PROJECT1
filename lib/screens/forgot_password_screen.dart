import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني", style: GoogleFonts.poppins()),
          backgroundColor: AppColors.surface,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "حدث خطأ، حاول مرة أخرى";
      if (e.code == 'user-not-found') message = "لا يوجد حساب مرتبط بهذا البريد";
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message, style: GoogleFonts.poppins()), backgroundColor: AppColors.surface),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: AppColors.textOnDark),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder, width: 1),
                    ),
                    child: const Icon(Icons.mark_email_read_outlined, color: AppColors.secondary, size: 36),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Forgot Password?",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter your email and we'll send you a link to reset your password.",
                    style: GoogleFonts.poppins(
                      color: AppColors.textLight,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder, width: 1),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (v) => (v == null || !v.contains('@')) ? 'يرجى إدخال بريد إلكتروني صحيح' : null,
                      style: GoogleFonts.poppins(color: AppColors.textOnDark),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: GoogleFonts.poppins(color: AppColors.textLight),
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.secondary),
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendResetLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 22, width: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              "Send Reset Link",
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Back to Login",
                        style: GoogleFonts.poppins(color: AppColors.secondary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}