import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe_model.dart';
import 'recipe_details_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final Function(String) onFavoriteToggle;
  final bool Function(String) isFavorite;
  final Function(List<Recipe>)? onRecipesLoaded;

  const HomeScreen({
    super.key,
    required this.onFavoriteToggle,
    required this.isFavorite,
    this.onRecipesLoaded,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = [];
  List<Recipe> popularRecipes = [];
  List<Recipe> trendingRecipes = [];
  List<Recipe> quickMealsRecipes = [];
  List<Recipe> filteredRecipes = []; // للوصفات المفلترة حسب الفئة
  bool isLoading = true;
  bool isSearching = false;
  String currentCategory = "All"; // عشان نتذكر الفئة الحالية
  
  final TextEditingController searchCtrl = TextEditingController();
  Timer? _debounceTimer;

  final List<Map<String, String>> categories = [
    {"name": "All", "icon": "🍽️", "query": ""},
    {"name": "Dessert", "icon": "🍰", "query": "Dessert"},
    {"name": "Chicken", "icon": "🍗", "query": "Chicken"},
    {"name": "Beef", "icon": "🥩", "query": "Beef"},
  ];

  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() => isLoading = true);
    
    try {
      final allRecipes = await ApiService.getDiverseRecipes();
      setState(() {
        recipes = allRecipes;
        popularRecipes = allRecipes.take(6).toList();
        trendingRecipes = allRecipes.where((r) => r.rating >= 4.5).take(8).toList();
        quickMealsRecipes = allRecipes.where((r) => r.cookingMinutes <= 30).take(8).toList();
        filteredRecipes = [];
        isLoading = false;
        isSearching = false;
        currentCategory = "All";
      });
      widget.onRecipesLoaded?.call(recipes);
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error loading data: $e");
    }
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      await _loadAllData();
      return;
    }
    
    setState(() {
      isSearching = true;
      isLoading = true;
    });
    
    try {
      final results = await ApiService.getRecipes(query);
      setState(() {
        recipes = results;
        popularRecipes = results.where((r) => r.rating >= 4.5).take(6).toList();
        trendingRecipes = results.where((r) => r.rating >= 4.5).take(8).toList();
        quickMealsRecipes = results.where((r) => r.cookingMinutes <= 30).take(8).toList();
        filteredRecipes = [];
        isLoading = false;
        isSearching = false;
        currentCategory = "All";
        selectedCategory = "All";
      });
      widget.onRecipesLoaded?.call(recipes);
    } catch (e) {
      setState(() {
        isLoading = false;
        isSearching = false;
      });
    }
  }

  // دالة جديدة للفلترة حسب الفئة
  Future<void> _filterByCategory(String categoryName, String categoryQuery) async {
    if (categoryName == "All" || categoryQuery.isEmpty) {
      // لو اختار "All" نرجع للشاشة الرئيسية كاملة
      await _loadAllData();
      return;
    }
    
    setState(() {
      isLoading = true;
      selectedCategory = categoryName;
      currentCategory = categoryName;
    });
    
    try {
      final results = await ApiService.getRecipesByCategory(categoryQuery);
      setState(() {
        filteredRecipes = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error filtering by category: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.orange))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchCtrl,
                          onChanged: _onSearchChanged,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "Search recipes...",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            prefixIcon: const Icon(Icons.search, color: Colors.orange, size: 24),
                            suffixIcon: isSearching
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    _buildHeroSection(),
                    const SizedBox(height: 24),

                    // Categories Section (من غير View All)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Categories",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category['name'];
                          
                          return GestureDetector(
                            onTap: () => _filterByCategory(category['name']!, category['query']!),
                            child: Container(
                              width: 85,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.orange.shade800, Colors.orange.shade600],
                                      )
                                    : LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.grey.shade800, Colors.grey.shade700],
                                      ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(category['icon']!, style: const TextStyle(fontSize: 28)),
                                  const SizedBox(height: 6),
                                  Text(
                                    category['name']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // عرض محتوى مختلف حسب الفئة المختارة
                    if (selectedCategory == "All") ...[
                      // لو في All: نعرض كل الأقسام
                      const SizedBox(height: 24),
                      
                      // Trending Now Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Trending Now",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: trendingRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = trendingRecipes[index];
                            return _buildHorizontalRecipeCard(recipe);
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 30 Min Meals Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "30 Min Meals",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: quickMealsRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = quickMealsRecipes[index];
                            return _buildHorizontalRecipeCard(recipe);
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Popular Recipes Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Popular Recipes",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: popularRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = popularRecipes[index];
                          return _buildRecipeCard(recipe);
                        },
                      ),
                    ] else if (filteredRecipes.isNotEmpty) ...[
                      // لو في فئة معينة: نعرض الوصفات المفلترة بس
                      const SizedBox(height: 24),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "$selectedCategory Recipes",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = filteredRecipes[index];
                          return _buildRecipeCard(recipe);
                        },
                      ),
                    ] else ...[
                      // لو في فئة معينة ومفيش وصفات
                      const SizedBox(height: 100),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.no_food, color: Colors.grey.shade600, size: 80),
                            const SizedBox(height: 16),
                            Text(
                              "No recipes found",
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black.withValues(alpha: 0.5), Colors.black.withValues(alpha: 0.3)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Make your day",
                style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1),
              ),
              SizedBox(height: 4),
              Text(
                "Delicious with\nour recipes",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalRecipeCard(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailPage(recipeId: int.tryParse(recipe.id) ?? 0),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      recipe.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.restaurant, color: Colors.orange, size: 40),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => widget.onFavoriteToggle(recipe.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.isFavorite(recipe.id) ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 10),
                          const SizedBox(width: 2),
                          Text("${recipe.rating}", style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: Colors.grey, size: 10),
                      const SizedBox(width: 2),
                      Text("${recipe.cookingMinutes} min", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailPage(recipeId: int.tryParse(recipe.id) ?? 0),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      recipe.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.restaurant, color: Colors.orange, size: 40),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => widget.onFavoriteToggle(recipe.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.isFavorite(recipe.id) ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 10),
                          const SizedBox(width: 2),
                          Text("${recipe.rating}", style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: Colors.grey, size: 10),
                      const SizedBox(width: 2),
                      Text("${recipe.cookingMinutes} min", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}