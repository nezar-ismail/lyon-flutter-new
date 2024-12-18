// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:lyon/v_done/models/common_response.dart';

class GlobalException implements Exception {
  final String message;
  final int? statusCode;
  final String? error;

  GlobalException({
    this.message = 'An unknown error occurred.',
    this.error = 'unknown',
    this.statusCode,
  });

  @override
  String toString() => '[$statusCode].$message. Error : $error';

  // Factory method to return appropriate response type based on status code
  /// Converts a Dio [Response] to a [ResponsModel].
  ///
  /// This method will return the appropriate [ResponsModel] based on the status code of the response.
  /// If the status code is not recognized, it will return a [ServerErrorResponse].
  ///
  /// If the status code is 400, the method will extract the errors from the response and return a [BadRequestResponse].
  /// If the status code is 401, the method will return an [UnAuthorizedResponse].
  /// If the status code is 403, the method will return a [ForbiddenResponse].
  /// If the status code is 500, the method will return a [ServerErrorResponse].
  /// If the status code is 409, the method will return a [ConflictResponse].
  static ResponsModel fromResponse(Response response) {
    final String message =
        response.data['message'] ?? 'An unknown error occurred.';
    final String error = response.data['error'] ?? 'unknown';
    final int? statusCode = response.statusCode;

    if (response.statusCode == 401) {
      return UnAuthorizedResponse();
    } else if (response.statusCode == 400) {
      List<String> listErrors = [];
      if (response.data['errors'] != null) {
        (response.data['errors'] as Map<String, dynamic>).forEach((key, value) {
          if (value is List) {
            listErrors.addAll(value.map((e) => '$key: $e').toList());
          } else {
            listErrors.add('$key: $value');
          }
        });
      }
      return BadRequestResponse(listErrors: listErrors);
    } else if (response.statusCode == 500) {
      return ServerErrorResponse();
    } else if (response.statusCode == 403) {
      return ForbiddenResponse();
    }else if (response.statusCode == 409) {
      return ConflictResponse();
    }else {
      return ServerErrorResponse();
    }
  }
}