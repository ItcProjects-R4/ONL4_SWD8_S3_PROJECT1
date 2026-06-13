import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe_model.dart';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  const RecipeDetailPage({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  Recipe? recipe;
  bool loading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadRecipeDetails();
  }

  Future<void> loadRecipeDetails() async {
    setState(() {
      loading = true;
      errorMessage = '';
    });
    
    try {
      final loadedRecipe = await ApiService.getRecipeDetails(widget.recipeId);
      setState(() {
        recipe = loadedRecipe;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "Failed to load recipe details. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.orange, size: 60),
              const SizedBox(height: 16),
              Text(errorMessage, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loadRecipeDetails,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Try Again", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      );
    }

    if (recipe == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("No Data", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: recipe!.id,
              child: Image.network(
                recipe!.imageUrl,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 280,
                    color: Colors.grey[800],
                    child: const Icon(Icons.food_bank, color: Colors.orange, size: 60),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                recipe!.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${recipe!.cookingMinutes} min",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.people_outline, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${recipe!.servings} servings",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Ingredients",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            recipe!.ingredients.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "No ingredients available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recipe!.ingredients.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                recipe!.ingredients[i],
                                style: const TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ),
                            if (recipe!.measures.isNotEmpty && i < recipe!.measures.length)
                              Text(
                                recipe!.measures[i],
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Steps",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            recipe!.steps.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "No steps available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recipe!.steps.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "${i + 1}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                recipe!.steps[i],
                                style: const TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}