import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(seenOnboarding: seenOnboarding, isLoggedIn: user != null));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final bool isLoggedIn;

  const MyApp({super.key, required this.seenOnboarding, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    
      home: isLoggedIn 
          ? const HomeScreen() 
          : (seenOnboarding ? const LoginScreen() : const OnboardingScreen()),
    );
  }
}