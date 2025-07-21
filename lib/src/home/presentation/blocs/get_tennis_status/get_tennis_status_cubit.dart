import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/src/home/domain/usecases/get_tennis_Status_use_case.dart';

part 'get_tennis_status_state.dart';

class GetTennisStatusCubit extends Cubit<GetTennisStatusState> {
  GetTennisStatusCubit({required GetTennisStatusUseCase getTennisStatusUseCase})
    : _getTennisStatusUseCase = getTennisStatusUseCase,
      super(GetTennisStatusInitial());

  final GetTennisStatusUseCase _getTennisStatusUseCase;

  Future<void> getTennisStatus({
    required double temperature,
    required int humidity,
    required int weatherCode,
  }) async {
    emit(const GetTennisStatusInProgress());

    final result = await _getTennisStatusUseCase(
      GetTennisStatusParams(
        temperature: temperature,
        humidity: humidity,
        weatherCode: weatherCode,
      ),
    );
    result.fold(
      (failure) => emit(GetTennisStatusFailed(failure.message)),
      (status) => emit(GetTennisStatusSuccess(status)),
    );
  }
}
