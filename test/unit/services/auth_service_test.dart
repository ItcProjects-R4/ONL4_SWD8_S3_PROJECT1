import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipes/services/auth_service.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  UserCredential,
  User,
])
void main() {
  late MockFirebaseAuth mockAuth;
  late AuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth();

    authService = AuthService(
      auth: mockAuth,
    );
  });

  group('AuthService', () {
    test('registerWithEmail returns user on success', () async {
      final mockCredential = MockUserCredential();
      final mockUser = MockUser();

      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.email).thenReturn('test@example.com');

      when(
        mockAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => mockCredential);

      final result = await authService.registerWithEmail(
        'test@example.com',
        'password123',
      );

      expect(result, isNotNull);
      expect(result?.email, 'test@example.com');
    });

    test('registerWithEmail returns null on failure', () async {
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenThrow(
        FirebaseAuthException(
          code: 'weak-password',
        ),
      );

      final result = await authService.registerWithEmail(
        'test@example.com',
        'password123',
      );

      expect(result, isNull);
    });

    test('loginWithEmail returns user on success', () async {
      final mockCredential = MockUserCredential();
      final mockUser = MockUser();

      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.email).thenReturn('test@example.com');

      when(
        mockAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => mockCredential);

      final result = await authService.loginWithEmail(
        'test@example.com',
        'password123',
      );

      expect(result, isNotNull);
      expect(result?.email, 'test@example.com');
    });

    test('loginWithEmail returns null on failure', () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenThrow(
        FirebaseAuthException(
          code: 'user-not-found',
        ),
      );

      final result = await authService.loginWithEmail(
        'test@example.com',
        'password123',
      );

      expect(result, isNull);
    });

    test('signOut calls FirebaseAuth.signOut', () async {
      when(mockAuth.signOut()).thenAnswer((_) async {});

      await authService.signOut();

      verify(mockAuth.signOut()).called(1);
    });

    test('currentUser returns current Firebase user', () {
      final mockUser = MockUser();

      when(mockAuth.currentUser).thenReturn(mockUser);

      expect(authService.currentUser, mockUser);
    });
  });
}