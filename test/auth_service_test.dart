import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:geonotes/core/security/auth_service.dart';
import 'mocks/firebase_mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockCredential;
  late MockUser mockUser;
  late AuthService authService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockCredential = MockUserCredential();
    mockUser = MockUser();

    when(() => mockCredential.user).thenReturn(mockUser);

    authService = AuthService(firebaseAuth: mockFirebaseAuth);
  });

  test('signInWithEmail devuelve un usuario cuando las credenciales son válidas', () async {
    when(() => mockFirebaseAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => mockCredential);

    final user = await authService.signInWithEmail(
      'test@test.com',
      '123456',
    );

    expect(user, isNotNull);
    verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
      email: 'test@test.com',
      password: '123456',
    )).called(1);
  });
}
