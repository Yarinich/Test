import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/network/beans/server_error_bean.dart';

ErrorState errorHandler(Object error, StackTrace stack) {
  const errorNetworkCode = 'Network error';

  if (error is DioError) {
    if (error.error is ServerErrorBean) {
      final serverError = error.error as ServerErrorBean;

      return ErrorState(
        msg:
            serverError.errors?.map((e) => e.message ?? '').toList().join('\n'),
        title: 'Error',
      );
    } else {
      return _onDioErrorHandler(error, stack);
    }
  } else if (error is PlatformException) {
    if (error.code == errorNetworkCode) {
      return NoNetworkState();
    }

    return ErrorState(msg: error.message);
  } else {
    return ErrorState(msg: error.toString());
  }
}

ErrorState _onDioErrorHandler(DioError error, StackTrace _) {
  if (isNetworkError(error)) {
    return NoNetworkState();
  }
  try {
    final dynamic data = error.response?.data['message'] ?? error.error;

    return ErrorState(msg: data.toString());
  } catch (e, stack) {
    log.e(
      'error',
      e,
      stack,
    );

    return ErrorState(msg: error.message);
  }
}

bool isNetworkError(Object error) {
  if (error is DioError) {
    final errorCode = error.error is SocketException
        ? (error.error as SocketException).osError?.errorCode ?? -1
        : null;

    return errorCode == 7 ||
        errorCode == 8 ||
        (error.response?.statusCode ?? -1) == 410;
  } else {
    return false;
  }
}
