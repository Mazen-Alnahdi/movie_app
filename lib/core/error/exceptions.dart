import 'package:equatable/equatable.dart';

class APIException extends Equatable implements Exception {
  final bool success;
  final String message;
  final int statusCode;

  APIException({
    required this.success,
    required this.message,
    required this.statusCode,
  });

  @override
  List<Object> get props => [success, message, statusCode];

  factory APIException.fromJson(Map<String, dynamic> json) {
    return APIException(
      success: json['success'] as bool,
      message: json['message'] as String,
      statusCode: json['statusCode'] as int,
    );
  }
}

class LocalException implements Exception {
  final String message;

  LocalException({required this.message});
}
