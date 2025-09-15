import 'package:dio/dio.dart';

class BadResponseException<T> implements Exception {
  BadResponseException({required this.message, this.response});
  final String message;
  final Response<T>? response;

  @override
  String toString() {
    return message;
  }
}
