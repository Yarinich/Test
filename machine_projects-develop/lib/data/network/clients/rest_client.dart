import 'package:cr_logger/cr_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:machine/data/network/beans/server_error_bean.dart';
import 'package:machine/data/network/request/base/base_request.dart';

class RestClient {
  RestClient._();

  static final instance = RestClient._();

  // Want to make it private in the future, main idea to use all network
  // requests throw RestClient via CRRequest and encapsulate Dio, but for this
  // we need add all Dio features such as <download>, it will decrease
  // dependency relation with Dio

  final dio = Dio();

  bool _loggerWasInitialized = false;

  void initDebugLog(BuildContext context) {
    // Dio interceptor init and debug button should be shown only in
    // dev or stage build or if debug mode.
    if (!kReleaseMode || kDebugMode && !_loggerWasInitialized) {
      final dioLogger = DioLogInterceptor(parserError: (data) {
        if (data is ServerErrorBean) {
          return data.toJson();
        }
        throw ArgumentError('Error model');
      });
      dio.interceptors.add(dioLogger);
      CRLoggerInitializer.instance.showDebugButton(context);
      _loggerWasInitialized = true;
    }
  }

  Future<Response<T>> request<T>(BaseRequest request) =>
      dio.fetch(request.options);
}
