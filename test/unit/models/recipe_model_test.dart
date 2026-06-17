import 'package:flutter_test/flutter_test.dart';
import 'package:recipes/models/recipe_model.dart';

void main() {
  group('Recipe Model - Constructor', () {
    test('creates Recipe with required fields', () {
      final recipe = Recipe(
        id: '1',
        name: 'Pasta',
        imageUrl: 'https://example.com/pasta.jpg',
        category: 'Pasta',
      );

      expect(recipe.id, '1');
      expect(recipe.name, 'Pasta');
      expect(recipe.imageUrl, 'https://example.com/pasta.jpg');
      expect(recipe.category, 'Pasta');
    });

    test('applies default values when optional fields are omitted', () {
      final recipe = Recipe(
        id: '2',
        name: 'Chicken',
        imageUrl: '',
        category: 'Chicken',
      );

      expect(recipe.area, '');
      expect(recipe.youtubeUrl, '');
      expect(recipe.rating, 4.5);
      expect(recipe.reviews, 100);
      expect(recipe.cookingMinutes, 30);
      expect(recipe.calories, 400);
      expect(recipe.servings, 4);
      expect(recipe.ingredients, isEmpty);
      expect(recipe.measures, isEmpty);
      expect(recipe.steps, isEmpty);
    });

    test('stores custom optional values correctly', () {
      final recipe = Recipe(
        id: '3',
        name: 'Beef Stew',
        imageUrl: 'https://img.com/stew.jpg',
        category: 'Beef',
        area: 'British',
        youtubeUrl: 'https://youtu.be/abc',
        rating: 4.8,
        reviews: 250,
        cookingMinutes: 90,
        calories: 650,
        servings: 6,
        ingredients: ['Beef', 'Carrot'],
        measures: ['500g', '2 pcs'],
        steps: ['Chop', 'Cook'],
      );

      expect(recipe.area, 'British');
      expect(recipe.youtubeUrl, 'https://youtu.be/abc');
      expect(recipe.rating, 4.8);
      expect(recipe.reviews, 250);
      expect(recipe.cookingMinutes, 90);
      expect(recipe.calories, 650);
      expect(recipe.servings, 6);
      expect(recipe.ingredients, ['Beef', 'Carrot']);
      expect(recipe.measures, ['500g', '2 pcs']);
      expect(recipe.steps, ['Chop', 'Cook']);
    });
  });

  group('Recipe.fromMealDB', () {
    test('parses basic fields correctly', () {
      final json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken Casserole',
        'strMealThumb': 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
        'strCategory': 'Chicken',
        'strArea': 'Japanese',
        'strYoutube': 'https://www.youtube.com/watch?v=4aZr5hZXP_s',
        'strInstructions': 'Step 1: Prepare chicken.\r\nStep 2: Cook in oven.',
      };

      final recipe = Recipe.fromMealDB(json);

      expect(recipe.id, '52772');
      expect(recipe.name, 'Teriyaki Chicken Casserole');
      expect(recipe.category, 'Chicken');
      expect(recipe.area, 'Japanese');
      expect(recipe.cookingMinutes, 45); // Chicken => 45 minutes
      expect(recipe.rating, 4.5);
      expect(recipe.reviews, 100);
      expect(recipe.calories, 500);
      expect(recipe.servings, 4);
    });

    test('extracts ingredients and measures up to 20 slots', () {
      final json = <String, dynamic>{
        'idMeal': '1',
        'strMeal': 'Test',
        'strMealThumb': '',
        'strCategory': 'Beef',
        'strInstructions': 'Do it.',
        'strIngredient1': 'Beef',
        'strMeasure1': '500g',
        'strIngredient2': 'Salt',
        'strMeasure2': '1 tsp',
        'strIngredient3': '',
        'strMeasure3': '',
      };

      final recipe = Recipe.fromMealDB(json);

      expect(recipe.ingredients, ['Beef', 'Salt']);
      expect(recipe.measures, ['500g', '1 tsp']);
    });

    test('splits instructions into steps by newline', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test',
        'strMealThumb': '',
        'strCategory': 'Dessert',
        'strInstructions': 'Mix flour.\r\nAdd eggs.\n\nBake at 180C.',
      };

      final recipe = Recipe.fromMealDB(json);

      expect(recipe.steps.length, 3);
      expect(recipe.steps[0], 'Mix flour.');
      expect(recipe.steps[1], 'Add eggs.');
      expect(recipe.steps[2], 'Bake at 180C.');
    });

    test('assigns 45 cookingMinutes for Dessert category', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Cake',
        'strMealThumb': '',
        'strCategory': 'Dessert',
        'strInstructions': 'Bake.',
      };
      expect(Recipe.fromMealDB(json).cookingMinutes, 45);
    });

    test('assigns 60 cookingMinutes for Beef category', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Steak',
        'strMealThumb': '',
        'strCategory': 'Beef',
        'strInstructions': 'Grill.',
      };
      expect(Recipe.fromMealDB(json).cookingMinutes, 60);
    });

    test('assigns 30 cookingMinutes for other categories', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Salad',
        'strMealThumb': '',
        'strCategory': 'Vegetarian',
        'strInstructions': 'Toss.',
      };
      expect(Recipe.fromMealDB(json).cookingMinutes, 30);
    });

    test('handles missing optional fields with defaults', () {
      final json = <String, dynamic>{
        'idMeal': null,
        'strMeal': null,
        'strMealThumb': null,
        'strCategory': null,
        'strInstructions': null,
      };

      final recipe = Recipe.fromMealDB(json);

      expect(recipe.id, '0');
      expect(recipe.name, 'Unknown');
      expect(recipe.imageUrl, '');
      expect(recipe.category, 'Other');
    });

    test('uses single step when instructions have no newlines', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test',
        'strMealThumb': '',
        'strCategory': 'Side',
        'strInstructions': 'Just mix everything together and serve.',
      };

      final recipe = Recipe.fromMealDB(json);
      expect(recipe.steps.length, 1);
    });
  });

  group('Recipe.fromSpoonacular', () {
    test('parses Spoonacular JSON correctly', () {
      final json = {
        'id': 716429,
        'title': 'Pasta with Garlic',
        'image': 'https://spoonacular.com/img/pasta.jpg',
        'readyInMinutes': 20,
        'servings': 2,
      };

      final recipe = Recipe.fromSpoonacular(json);

      expect(recipe.id, '716429');
      expect(recipe.name, 'Pasta with Garlic');
      expect(recipe.imageUrl, 'https://spoonacular.com/img/pasta.jpg');
      expect(recipe.category, 'Food');
      expect(recipe.cookingMinutes, 20);
      expect(recipe.servings, 2);
      expect(recipe.ingredients, isEmpty);
      expect(recipe.steps, isEmpty);
    });

    test('applies defaults for missing Spoonacular fields', () {
      final json = {
        'id': 100,
        'title': '',
        'image': '',
      };

      final recipe = Recipe.fromSpoonacular(json);

      expect(recipe.cookingMinutes, 30);
      expect(recipe.servings, 2);
    });
  });

  group('Recipe.fromDetailJson', () {
    test('parses detail JSON with extended ingredients and steps', () {
      final json = {
        'id': 99,
        'title': 'Pancakes',
        'image': 'https://img.com/pancakes.jpg',
        'dishTypes': ['breakfast'],
        'readyInMinutes': 15,
        'servings': 3,
        'extendedIngredients': [
          {'original': '1 cup flour'},
          {'original': '2 eggs'},
        ],
        'analyzedInstructions': [
          {
            'steps': [
              {'step': 'Mix ingredients.'},
              {'step': 'Cook on pan.'},
            ]
          }
        ],
      };

      final recipe = Recipe.fromDetailJson(json);

      expect(recipe.id, '99');
      expect(recipe.name, 'Pancakes');
      expect(recipe.category, 'breakfast');
      expect(recipe.cookingMinutes, 15);
      expect(recipe.servings, 3);
      expect(recipe.ingredients, ['1 cup flour', '2 eggs']);
      expect(recipe.steps, ['Mix ingredients.', 'Cook on pan.']);
    });

    test('falls back to "Food" category when dishTypes is empty', () {
      final json = {
        'id': 1,
        'title': 'Soup',
        'image': '',
        'dishTypes': [],
        'readyInMinutes': 30,
        'servings': 2,
        'extendedIngredients': [],
        'analyzedInstructions': [],
      };

      final recipe = Recipe.fromDetailJson(json);
      expect(recipe.category, 'Food');
    });

    test('returns empty steps on malformed analyzedInstructions', () {
      final json = {
        'id': 1,
        'title': 'X',
        'image': '',
        'dishTypes': null,
        'readyInMinutes': 10,
        'servings': 1,
        'extendedIngredients': null,
        'analyzedInstructions': [],
      };

      final recipe = Recipe.fromDetailJson(json);
      expect(recipe.steps, isEmpty);
    });
  });
}
