import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:recipes/models/recipe_model.dart';
import 'package:recipes/screens/favorites_page.dart';
import '../helpers/firebase_test_setup.dart';

void main() {

  final testRecipe = Recipe(
    id: '1',
    name: 'Test Recipe',
    imageUrl: 'https://example.com/image.jpg',
    category: 'Dessert',
    ingredients: ['Flour'],
    measures: ['1 cup'],
    youtubeUrl: '',
    rating: 4.5,
    cookingMinutes: 30,
    servings: 2,
    calories: 200,
    steps: ['Mix and bake'],
  );

  Widget createWidgetUnderTest({required Set<String> favoriteIds, required Function(String) onToggle}) {
    return MaterialApp(
      home: FavoritesPage(
        allRecipes: [testRecipe],
        favoriteIds: favoriteIds,
        onFavoriteToggle: onToggle,
      ),
    );
  }

  group('FavoritesPage Widget Tests', () {
    testWidgets('Displays empty state when no favorites exist', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest(favoriteIds: {}, onToggle: (_) {}));

        expect(find.text('Favorites'), findsOneWidget);
        expect(find.text('No Favorites Yet'), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
      });
    });

    testWidgets('Displays favorite recipes correctly', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest(favoriteIds: {'1'}, onToggle: (_) {}));

        expect(find.byType(GridView), findsOneWidget);
        expect(find.text('Test Recipe'), findsOneWidget);
        expect(find.text('No Favorites Yet'), findsNothing);
      });
    });

    testWidgets('Calls onFavoriteToggle when heart icon is tapped', (WidgetTester tester) async {
      String? toggledId;
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest(favoriteIds: {'1'}, onToggle: (id) => toggledId = id));

        await tester.tap(find.byIcon(Icons.favorite));
        await tester.pump();

        expect(toggledId, '1');
      });
    });
  });
}