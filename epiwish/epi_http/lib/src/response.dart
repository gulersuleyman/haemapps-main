import 'dart:developer';

enum Status { success, error, unknown }

final class EpiResponse<T> {
  final Status status;
  final String? message;
  final T data;

  EpiResponse._({
    required this.status,
    this.message,
    required this.data,
  });

  static EpiResponse<T> success<T>(T data, {String? message}) {
    log('✅ Success: $message');
    return EpiResponse._(status: Status.success, message: message, data: data);
  }

  static EpiResponse<T> error<T>(T data, {String? message}) {
    log('❌ Error: $message');
    return EpiResponse._(status: Status.error, message: message, data: data);
  }

  static EpiResponse<T> unknown<T>(T data, {String? message}) {
    log('❓ Unknown: $message');
    return EpiResponse._(status: Status.unknown, message: message, data: data);
  }

  @override
  String toString() {
    return 'Response(status: $status, message: $message, data: $data)';
  }
}
