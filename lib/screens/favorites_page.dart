import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import 'recipe_details_screen.dart';

class FavoritesPage extends StatelessWidget {
  final List<Recipe> allRecipes;
  final Set<String> favoriteIds;
  final Function(String) onFavoriteToggle;

  const FavoritesPage({
    super.key,
    required this.allRecipes,
    required this.favoriteIds,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final favRecipes = allRecipes.where((r) => favoriteIds.contains(r.id)).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Favorites", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: favRecipes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No Favorites Yet", style: TextStyle(color: Colors.grey, fontSize: 18)),
                  SizedBox(height: 8),
                  Text("Tap the heart icon on any recipe to add it here", style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favRecipes.length,
              itemBuilder: (context, i) {
                final r = favRecipes[i];
                return _buildFavoriteCard(context, r);
              },
            ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailPage(
              recipeId: int.tryParse(recipe.id) ?? 0,
            ),
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
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.grey[800], child: const Icon(Icons.food_bank, color: Colors.orange));
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => onFavoriteToggle(recipe.id),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite, color: Colors.red, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                recipe.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}