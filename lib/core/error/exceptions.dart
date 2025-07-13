import 'package:equatable/equatable.dart';

class LocalException extends Equatable implements Exception {
  final String message;
  final String statusCode;

  LocalException({required this.message, required this.statusCode});

  @override
  List<Object> get props => [message, statusCode];
}

class ServerException extends Equatable implements Exception {
  final String message;
  final String statusCode;

  const ServerException({required this.message, required this.statusCode});

  @override
  List<Object> get props => [message, statusCode];
}

class APIException extends Equatable implements Exception {
  final String message;
  final String statusCode;

  const APIException({required this.message, required this.statusCode});

  @override
  List<Object> get props => [message, statusCode];
}
