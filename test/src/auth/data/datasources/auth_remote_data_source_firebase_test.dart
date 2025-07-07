import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/auth/data/datasources/auth_remote_data_source_firebase.dart';

// Mocks
class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockUser extends Mock implements firebase_auth.User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthRemoteDataSourceFirebase authRemoteDataSource;
  late FakeFirebaseFirestore fakeFirestore;

  const tEmail = "test@test.com";
  const tPassword = "password";
  const tName = "Test User";

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    fakeFirestore = FakeFirebaseFirestore();

    when(() => mockUser.uid).thenReturn("test_uid");
    when(() => mockUser.email).thenReturn(tEmail);
    when(() => mockUser.displayName).thenReturn(tName);

    authRemoteDataSource = AuthRemoteDataSourceFirebase(
      fireStore: fakeFirestore,
      firebaseAuth: mockFirebaseAuth,
    );
  });

  //used chatgpt to fix the document error
  group('signUpWithEmailAndPassword', () {
    test(
      'Should return AuthUserModel when signUpWithEmailAndPassword is successful',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        when(() => mockUserCredential.user).thenReturn(mockUser);

        // Act
        final result = await authRemoteDataSource.signUpWithEmailAndPassword(
          name: tName,
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result.id, equals("test_uid"));
        expect(result.email, equals(tEmail));
        expect(result.name, equals(tName));

        // Verify Firestore has the user document
        final userSnapshot = await fakeFirestore
            .collection('users')
            .doc("test_uid")
            .get();

        expect(userSnapshot.exists, isTrue);
        expect(userSnapshot.data()?['email'], equals(tEmail));
        expect(userSnapshot.data()?['name'], equals(tName));
      },
    );

    test(
      'Should throw Exception when signUpWithEmailAndPassword fails',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(Exception());

        final call = authRemoteDataSource.signUpWithEmailAndPassword;

        expect(
          () => call(name: tName, email: tEmail, password: tPassword),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('signInWithEmailAndPassword', () {
    test(
      'should call signInWithEmailAndPassword on FirebaseAuth with correct Email and Password',
      () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        when(() => mockUserCredential.user).thenReturn((mockUser));

        final result = await authRemoteDataSource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result.id, equals('test_uid'));
        expect(result.email, equals(tEmail));
      },
    );
    test(
      'should throw an Exception when FirebaseAuth throws an Exception',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(Exception());

        final call = authRemoteDataSource.signInWithEmailAndPassword;
        expect(
          () => call(email: tEmail, password: tPassword),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('signOut', () {
    test('should Call signOut on FirebaseAuth', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      await authRemoteDataSource.signOut();

      verify(() => mockFirebaseAuth.signOut());
    });

    test(
      'should throw an Exception when FirebaseAuth throws an exception',
      () async {
        when(
          () => mockFirebaseAuth.signOut(),
        ).thenThrow(Exception('Sign out failed: test error'));

        final call = authRemoteDataSource.signOut;

        expect(() => call(), throwsA(isA<Exception>()));
      },
    );
  });
}
