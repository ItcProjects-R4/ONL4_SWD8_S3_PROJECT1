import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(_newPassController.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم تغيير كلمة المرور بنجاح", style: GoogleFonts.poppins()),
          backgroundColor: AppColors.surface,
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "حدث خطأ، حاول مرة أخرى";
      if (e.code == 'requires-recent-login') {
        message = "يرجى تسجيل الدخول مرة أخرى قبل تغيير كلمة المرور";
      }
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.textOnDark),
          ),
        ),
        title: Text(
          "Change Password",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textOnDark),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder, width: 1),
                    ),
                    child: const Icon(Icons.lock_reset_rounded, color: AppColors.secondary, size: 36),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Set New Password",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your new password must be different from previous passwords.",
                    style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    hint: "New Password",
                    icon: Icons.lock_outline,
                    controller: _newPassController,
                    obscure: _isObscure,
                    onToggleObscure: () => setState(() => _isObscure = !_isObscure),
                    validator: (v) => (v == null || v.length < 6) ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    hint: "Confirm New Password",
                    icon: Icons.lock_reset_rounded,
                    controller: _confirmPassController,
                    obscure: _isConfirmObscure,
                    onToggleObscure: () => setState(() => _isConfirmObscure = !_isConfirmObscure),
                    validator: (v) => (v != _newPassController.text) ? 'كلمة المرور غير متطابقة' : null,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 22, width: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text("Save Changes", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
    required bool obscure,
    required VoidCallback onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: GoogleFonts.poppins(color: AppColors.textOnDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: AppColors.textLight),
          prefixIcon: Icon(icon, color: AppColors.secondary),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.textLight,
            ),
            onPressed: onToggleObscure,
          ),
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }
}