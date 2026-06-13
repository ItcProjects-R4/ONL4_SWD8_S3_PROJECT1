
class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String area;
  final String youtubeUrl;
  
  final double rating;
  final int reviews;
  final int cookingMinutes;
  final int calories;
  final int servings;
  
  final List<String> ingredients;
  final List<String> measures;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.area = '',
    this.youtubeUrl = '',
    this.rating = 4.5,
    this.reviews = 100,
    this.cookingMinutes = 30,
    this.calories = 400,
    this.servings = 4,
    this.ingredients = const [],
    this.measures = const [],
    this.steps = const [],
  });

  /// ✅ من TheMealDB API
  factory Recipe.fromMealDB(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];
    
    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] ?? '';
      String measure = json['strMeasure$i'] ?? '';
      
      if (ingredient.isNotEmpty && ingredient.trim() != '') {
        ingredients.add(ingredient.trim());
        measures.add(measure.trim());
      }
    }
    
    String instructions = json['strInstructions'] ?? '';
    List<String> steps = instructions
        .split(RegExp(r'[\r\n]+'))
        .where((s) => s.trim().isNotEmpty)
        .toList();
    
    if (steps.isEmpty && instructions.isNotEmpty) {
      steps = [instructions];
    }
    
    int cookingMinutes = 30;
    String category = json['strCategory'] ?? '';
    if (category == 'Dessert') cookingMinutes = 45;
    if (category == 'Beef') cookingMinutes = 60;
    if (category == 'Chicken') cookingMinutes = 45;
    
    return Recipe(
      id: json['idMeal']?.toString() ?? '0',
      name: json['strMeal'] ?? 'Unknown',
      imageUrl: json['strMealThumb'] ?? '',
      category: category.isNotEmpty ? category : 'Other',
      area: json['strArea'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
      cookingMinutes: cookingMinutes,
      servings: 4,
      rating: 4.5,
      reviews: 100,
      calories: 500,
      ingredients: ingredients,
      measures: measures,
      steps: steps,
    );
  }


  factory Recipe.fromSpoonacular(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'].toString(),
      name: json['title'] ?? '',
      imageUrl: json['image'] ?? '',
      category: 'Food',
      cookingMinutes: json['readyInMinutes'] ?? 30,
      calories: 400,
      servings: json['servings'] ?? 2,
      ingredients: [],
      steps: [],
    );
  }


  factory Recipe.fromDetailJson(Map<String, dynamic> json) {
    List<String> ingredients = (json['extendedIngredients'] as List?)
            ?.map((e) => e['original'].toString())
            .toList() ??
        [];
    
    List<String> steps = [];
    try {
      final stepsData = json['analyzedInstructions'][0]['steps'] as List;
      steps = stepsData.map((s) => s['step'].toString()).toList();
    } catch (_) {}
    
    return Recipe(
      id: json['id'].toString(),
      name: json['title'] ?? '',
      imageUrl: json['image'] ?? '',
      category: json['dishTypes'] != null && json['dishTypes'].isNotEmpty
          ? json['dishTypes'][0]
          : 'Food',
      cookingMinutes: json['readyInMinutes'] ?? 30,
      servings: json['servings'] ?? 1,
      ingredients: ingredients,
      steps: steps,
    );
  }
}