import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:recipes/screens/home_screen.dart';
import 'package:recipes/services/api_service.dart';

import '../unit/services/api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;

  setUpAll(() {
    mockClient = MockClient();
    ApiService.client = mockClient;
    
    // Default mock response
    when(mockClient.get(any)).thenAnswer(
      (_) async => http.Response('{"meals": []}', 200),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: HomeScreen(
        onFavoriteToggle: (id) {},
        isFavorite: (id) => false,
        onRecipesLoaded: (recipes) {},
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('Renders Search Bar and Hero Section', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Search recipes...'), findsOneWidget);
        expect(find.text('Delicious with\nour recipes'), findsOneWidget);
      });
    });

    testWidgets('Renders Categories', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Categories'), findsOneWidget);
        expect(find.text('All'), findsWidgets);
        expect(find.text('Dessert'), findsOneWidget);
        expect(find.text('Chicken'), findsOneWidget);
        expect(find.text('Beef'), findsOneWidget);
      });
    });

    testWidgets('Displays Popular Recipes section', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Popular Recipes'), findsOneWidget);
      });
    });
  });
}