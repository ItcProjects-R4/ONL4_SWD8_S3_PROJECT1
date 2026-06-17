import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:recipes/screens/recipe_details_screen.dart';
import 'package:recipes/services/api_service.dart';

import '../unit/services/api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;

  setUpAll(() {
    mockClient = MockClient();
    ApiService.client = mockClient;
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: RecipeDetailPage(recipeId: 52772),
    );
  }

  group('RecipeDetailsScreen Widget Tests', () {
    testWidgets('Displays loading indicator initially', (WidgetTester tester) async {
      when(mockClient.get(any)).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return http.Response(jsonEncode({'meals': []}), 200);
        },
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();
      });
    });

    testWidgets('Displays recipe details successfully', (WidgetTester tester) async {
      final mockResponse = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Teriyaki Chicken Casserole',
            'strMealThumb': 'https://example.com/image.jpg',
            'strCategory': 'Chicken',
            'strInstructions': 'Step 1.\r\nStep 2.',
            'strIngredient1': 'Chicken',
            'strMeasure1': '1 kg',
          }
        ]
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Teriyaki Chicken Casserole'), findsOneWidget);
        expect(find.text('Ingredients'), findsOneWidget);
        expect(find.text('Chicken'), findsOneWidget);
        expect(find.text('1 kg'), findsOneWidget);
        expect(find.text('Steps'), findsOneWidget);
        expect(find.text('Step 1.'), findsOneWidget);
        expect(find.text('Step 2.'), findsOneWidget);
      });
    });

    testWidgets('Displays error message on failure', (WidgetTester tester) async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Failed to load recipe details. Please try again.'), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
      });
    });
  });
}