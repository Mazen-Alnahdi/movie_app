import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/src/auth/domain/entities/auth_user.dart';

void main() {
  test("Empty AuthUser With correct default values", () {
    expect(AuthUser.empty().id, equals(""));
    expect(AuthUser.empty().email, equals(""));
    expect(AuthUser.empty().name, equals(""));
  });

  test("Two AuthUser instances with same values are equal", () {
    const user1 = AuthUser(id: 'id', email: 'email', name: 'name');
    const user2 = AuthUser(id: 'id', email: 'email', name: 'name');
    expect(user1, equals(user2));
  });

  test("Two AuthUser instances with same values are not equal", () {
    const user1 = AuthUser(id: 'id', email: 'email', name: 'name');
    const user2 = AuthUser(id: 'id1', email: 'email', name: 'name');
    expect(user1, isNot(equals(user2)));
  });

  test("Props return with correct properties", () {
    const user1 = AuthUser(id: 'id', email: 'email', name: 'name');
    expect(user1.props, equals(['id', 'email', 'name']));
  });

  test('Name can be null', () {
    const user1 = AuthUser(id: 'id', email: 'email');
    expect(user1.name, isNull);
  });
}
