import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class ApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";
  
  static Future<List<Recipe>> getRecipes(String query) async {
    if (query.isEmpty || query == "pasta" || query == "All") {
      return await getDiverseRecipes();
    }
    
    final url = Uri.parse("$baseUrl/search.php?s=$query");
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List meals = data['meals'] ?? [];
        
        if (meals.isNotEmpty && meals[0] != null) {
          return meals.map((meal) => Recipe.fromMealDB(meal)).toList();
        }
      }
      return await getDiverseRecipes();
      
    } catch (e) {
      return await getDiverseRecipes();
    }
  }
  
  static Future<List<Recipe>> getRecipesByKeyword(String keyword) async {
    final url = Uri.parse("$baseUrl/search.php?s=$keyword");
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List meals = data['meals'] ?? [];
        
        if (meals.isNotEmpty && meals[0] != null) {
          return meals.map((meal) => Recipe.fromMealDB(meal)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  
  static Future<List<Recipe>> getDiverseRecipes() async {
    List<Recipe> recipes = [];
    
    List<String> categories = [
      "Beef", "Chicken", "Dessert", "Pasta", "Seafood", 
      "Vegetarian", "Breakfast", "Lamb", "Pork", "Side"
    ];
    
    for (String category in categories) {
      final url = Uri.parse("$baseUrl/filter.php?c=$category");
      
      try {
        final response = await http.get(url);
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List meals = data['meals'] ?? [];
          
          if (meals.isNotEmpty && meals[0] != null) {
            final detailUrl = Uri.parse("$baseUrl/lookup.php?i=${meals[0]['idMeal']}");
            final detailResponse = await http.get(detailUrl);
            
            if (detailResponse.statusCode == 200) {
              final detailData = jsonDecode(detailResponse.body);
              final mealsDetail = detailData['meals'] ?? [];
              if (mealsDetail.isNotEmpty && mealsDetail[0] != null) {
                recipes.add(Recipe.fromMealDB(mealsDetail[0]));
              }
            }
          }
        }
      } catch (e) {
      }
    }
    
    return recipes;
  }
  
  static Future<List<Recipe>> getRecipesByCategory(String category) async {
    final url = Uri.parse("$baseUrl/filter.php?c=$category");
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List meals = data['meals'] ?? [];
        
        List<Recipe> recipes = [];
        for (int i = 0; i < meals.length && i < 8; i++) {
          final meal = meals[i];
          if (meal != null) {
            final detailUrl = Uri.parse("$baseUrl/lookup.php?i=${meal['idMeal']}");
            final detailResponse = await http.get(detailUrl);
            
            if (detailResponse.statusCode == 200) {
              final detailData = jsonDecode(detailResponse.body);
              final mealsDetail = detailData['meals'] ?? [];
              if (mealsDetail.isNotEmpty && mealsDetail[0] != null) {
                recipes.add(Recipe.fromMealDB(mealsDetail[0]));
              }
            }
          }
        }
        return recipes;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  
  static Future<Recipe> getRecipeDetails(int id) async {
    final url = Uri.parse("$baseUrl/lookup.php?i=$id");
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final meals = data['meals'] ?? [];
        if (meals.isNotEmpty && meals[0] != null) {
          return Recipe.fromMealDB(meals[0]);
        }
      }
      throw Exception("Recipe not found");
    } catch (e) {
      throw Exception("Failed to load recipe details");
    }
  }
}