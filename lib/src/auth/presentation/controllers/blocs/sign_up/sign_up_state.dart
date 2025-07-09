part of 'sign_up_cubit.dart';

// class SignUpState extends Equatable {
//   final String name;
//   final String email;
//   final String password;
//   final EmailStatus emailStatus;
//   final NameStatus nameStatus;
//   final PasswordStatus passwordStatus;
//
//   const SignUpState({
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.emailStatus,
//     required this.nameStatus,
//     required this.passwordStatus,
//   });
//
//   @override
//   List<Object> get props => [
//     name,
//     email,
//     password,
//     emailStatus,
//     nameStatus,
//     passwordStatus,
//   ];
//
//   SignUpState copyWith({
//     String? name,
//     String? email,
//     String? password,
//     EmailStatus? emailStatus,
//     NameStatus? nameStatus,
//     PasswordStatus? passwordStatus,
//   }) {
//     return SignUpState(
//       name: name ?? this.name,
//       email: email ?? this.email,
//       password: password ?? this.password,
//       emailStatus: emailStatus ?? this.emailStatus,
//       nameStatus: nameStatus ?? this.nameStatus,
//       passwordStatus: passwordStatus ?? this.passwordStatus,
//     );
//   }
// }

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpValid extends SignUpState {
  const SignUpValid();
}

class SignupInvalid extends SignUpState {
  const SignupInvalid();
}

class SignUpInProgress extends SignUpState {
  const SignUpInProgress();
}

class SignUpSuccess extends SignUpState {
  const SignUpSuccess(this.authUser);

  final AuthUser authUser;

  @override
  List<Object> get props => [authUser];
}

class SignUpFailed extends SignUpState {
  const SignUpFailed(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
