import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_colors.dart';
import 'screens/home_screen.dart';

import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_page.dart';
import 'screens/favorites_page.dart';
import 'models/recipe_model.dart' as model;
import 'services/fav_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(RecipeApp(seenOnboarding: seenOnboarding));
}

class RecipeApp extends StatelessWidget {
  final bool seenOnboarding;

  const RecipeApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.secondary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: seenOnboarding ? const AuthGate() : const OnboardingScreen(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainShell();
        }

        return const LoginScreen();
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  Set<String> _favorites = {};
  List<model.Recipe> _allRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await FavStorage.loadFavorites();
    setState(() {
      _favorites = favs;
    });
  }

  void _toggleFavorite(String id) async {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
    await FavStorage.saveFavorites(_favorites);
  }

  bool _isFavorite(String id) {
    return _favorites.contains(id);
  }

  void _updateRecipes(List<model.Recipe> recipes) {
    setState(() {
      _allRecipes = recipes;
    });
  }

  List<Widget> get _screens => [
        HomeScreen(
          onFavoriteToggle: _toggleFavorite,
          isFavorite: _isFavorite,
          onRecipesLoaded: _updateRecipes,
        ),
        FavoritesPage(
          allRecipes: _allRecipes,
          favoriteIds: _favorites,
          onFavoriteToggle: _toggleFavorite,
        ),
        const ProfilePage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}