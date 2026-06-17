import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipes/models/recipe_model.dart';
import 'package:recipes/services/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;

  setUpAll(() {
    mockClient = MockClient();
    ApiService.client = mockClient;
  });

  group('ApiService', () {
    test('getRecipeDetails returns a valid Recipe on 200 OK', () async {
      final mockResponse = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Teriyaki Chicken Casserole',
            'strCategory': 'Chicken',
          }
        ]
      };

      when(mockClient.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772')))
          .thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final recipe = await ApiService.getRecipeDetails(52772);

      expect(recipe, isA<Recipe>());
      expect(recipe.id, '52772');
      expect(recipe.name, 'Teriyaki Chicken Casserole');
    });

    test('getRecipeDetails throws exception when meals array is empty', () async {
      final mockResponse = {'meals': []};

      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      expect(() => ApiService.getRecipeDetails(123), throwsException);
    });

    test('getRecipesByKeyword returns recipes on success', () async {
      final mockResponse = {
        'meals': [
          {'idMeal': '1', 'strMeal': 'Pasta'},
          {'idMeal': '2', 'strMeal': 'Pizza'}
        ]
      };

      when(mockClient.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=pasta')))
          .thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final recipes = await ApiService.getRecipesByKeyword('pasta');

      expect(recipes.length, 2);
      expect(recipes[0].name, 'Pasta');
      expect(recipes[1].name, 'Pizza');
    });

    test('getRecipesByKeyword returns empty list on failure', () async {
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('Not Found', 404));

      final recipes = await ApiService.getRecipesByKeyword('pasta');

      expect(recipes, isEmpty);
    });
  });
}