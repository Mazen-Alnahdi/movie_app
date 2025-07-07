import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/src/auth/data/models/auth_user_model.dart';

void main() {
  late MockUser mockUser;

  setUp(() {
    mockUser = MockUser(
      uid: 'testId',
      email: "test@test.com",
      displayName: "testName",
    );
  });

  const id = 'testId';
  const email = 'test@test.com';
  const name = 'testName';

  const authUserModel = AuthUserModel(id: id, email: email, name: name);

  group("AuthUserModel", () {
    test('properties are correctly assigned on creation', () {
      expect(authUserModel.id, equals(id));
      expect(authUserModel.name, equals(name));
      expect(authUserModel.email, equals(email));
    });

    test("creates AuthUserModel from FirebaseUser", () {
      final authUserModel = AuthUserModel.fromFirebaseAuthUser(mockUser);

      expect(authUserModel.id, equals(mockUser.uid));
      expect(authUserModel.name, equals(mockUser.displayName));
      expect(authUserModel.email, equals(mockUser.email));
    });

    test("converts to entity correctly", () {
      final authUser = authUserModel.toEntity();

      expect(authUser.id, equals(id));
      expect(authUser.name, equals(name));
      expect(authUser.email, equals(email));
    });

    test("get props returns a list of all properties", () {
      final props = authUserModel.props;

      expect(props, equals([id, email, name]));
    });

    test("handles null values in firebase user correctly", () {
      //Fix the Test to use the same MockUser and update to null
      final mockUser1 = mockUser.copyWith(email: '');
      mockUser1.displayName = null;

      final authUserModel = AuthUserModel.fromFirebaseAuthUser(mockUser1);

      expect(authUserModel.email, equals(''));
      expect(authUserModel.name, isNull);
      // expect(actual, matcher)
    });
  });
}
