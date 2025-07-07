import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({required this.id, required this.email, this.name});

  const AuthUser.empty() : this(id: '', name: '', email: '');

  // static const AuthUser empty = AuthUser(id: '', name: '', email: '');
  //
  // bool get isEmpty => this == AuthUser.empty;

  final String id;
  final String email;
  final String? name;

  @override
  List<Object?> get props => [id, email, name];
}
