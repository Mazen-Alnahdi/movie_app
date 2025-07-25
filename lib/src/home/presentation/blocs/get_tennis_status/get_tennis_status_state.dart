part of 'get_tennis_status_cubit.dart';

abstract class GetTennisStatusState extends Equatable {
  const GetTennisStatusState();

  @override
  List<Object?> get props => [];
}

class GetTennisStatusInitial extends GetTennisStatusState {
  const GetTennisStatusInitial();
}

class GetTennisStatusInProgress extends GetTennisStatusState {
  const GetTennisStatusInProgress();
}

class GetTennisStatusSuccess extends GetTennisStatusState {
  const GetTennisStatusSuccess(this.status);
  final int status;
  @override
  List<Object?> get props => [status];
}

class GetTennisStatusFailed extends GetTennisStatusState {
  const GetTennisStatusFailed(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
