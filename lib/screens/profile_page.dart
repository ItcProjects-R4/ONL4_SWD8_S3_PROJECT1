import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import 'login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  int weeklyLaunches = 0;
  String? lastLoginDate;
  String? memberSince;
  String? lastActualLogin; // ده هيخزن تاريخ آخر تسجيل دخول حقيقي

  @override
  void initState() {
    super.initState();
    _loadStats();
    _getMemberSince();
    _updateLastLogin(); // دالة جديدة لتحديث آخر تسجيل دخول
  }

  // دالة جديدة: تسجل وقت آخر تسجيل دخول كل ما المستخدم يفتح البروفايل
  Future<void> _updateLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = "${now.day}/${now.month}/${now.year}";
    
    // نجيب آخر تسجيل دخول مسجل قبل كده
    final savedLastLogin = prefs.getString('last_login_date');
    
    setState(() {
      if (savedLastLogin != null) {
        lastActualLogin = savedLastLogin;
      } else {
        lastActualLogin = todayStr; // أول مرة يسجل فيها
      }
    });
    
    // نحفظ التاريخ الحالي كآخر تسجيل دخول للمرة الجاية
    await prefs.setString('last_login_date', todayStr);
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    // نجلب تاريخ آخر مرة فتح فيها التطبيق (مختلف عن تسجيل الدخول)
    final lastLaunchStr = prefs.getString('last_launch_date');
    
    setState(() {
      weeklyLaunches = prefs.getInt('weekly_launches') ?? 0;
      
      if (lastLaunchStr != null) {
        final date = DateTime.parse(lastLaunchStr);
        lastLoginDate = "${date.day}/${date.month}/${date.year}";
      } else {
        lastLoginDate = "اليوم";
      }
    });
  }

  void _getMemberSince() {
    if (user != null && user!.metadata.creationTime != null) {
      final date = user!.metadata.creationTime!;
      setState(() {
        memberSince = "${date.day}/${date.month}/${date.year}";
      });
    } else {
      // لو معندناش تاريخ من Firebase، نستخدم SharedPreferences
      _getMemberSinceFromPrefs();
    }
  }

  // دالة احتياطية لو Firebase مردش التاريخ
  Future<void> _getMemberSinceFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMemberSince = prefs.getString('member_since');
    
    if (savedMemberSince != null) {
      setState(() {
        memberSince = savedMemberSince;
      });
    } else {
      // لو أول مرة، نسجل التاريخ الحالي
      final now = DateTime.now();
      final todayStr = "${now.day}/${now.month}/${now.year}";
      await prefs.setString('member_since', todayStr);
      setState(() {
        memberSince = todayStr;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.secondary.withOpacity(0.8), AppColors.background],
                  ),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // هنا شلنا الصورة الثابتة وحطينا أيقونة ديناميكية
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary.withOpacity(0.3),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(user?.displayName ?? "Chef User", style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 5),
                    Text(user?.email ?? "No Email", style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildStatCard(icon: Icons.timer, value: "$weeklyLaunches", label: "App Opens / Week", color: Colors.orange),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.cardBorder)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Account Info", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Divider(color: AppColors.cardBorder, height: 30),
                    _buildInfoRow(Icons.email_outlined, "Email", user?.email ?? "No Email"),
                    const SizedBox(height: 15),
                    // هنا بنعرض آخر تسجيل دخول حقيقي مش ثابت
                    _buildInfoRow(Icons.calendar_today, "Last Login", lastActualLogin ?? "Unknown"),
                    const SizedBox(height: 15),
                    _buildInfoRow(Icons.star, "Member Since", memberSince ?? "Loading..."),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Sign Out"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String value, required String label, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 10),
            Text(value, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 22),
        const SizedBox(width: 15),
        Text(title, style: GoogleFonts.poppins(color: Colors.white70, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }
}