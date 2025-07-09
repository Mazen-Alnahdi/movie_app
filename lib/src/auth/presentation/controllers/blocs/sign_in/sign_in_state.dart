part of 'sign_in_cubit.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {
  const SignInInitial();
}

class SignInValid extends SignInState {
  const SignInValid();
}

class SignInInvalid extends SignInState {
  const SignInInvalid();
}

class SignInInProgress extends SignInState {
  const SignInInProgress();
}

class SignInSuccess extends SignInState {
  const SignInSuccess(this.authUser);

  final AuthUser authUser;

  @override
  List<Object> get props => [authUser];
}

class SignInFailed extends SignInState {
  const SignInFailed(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
