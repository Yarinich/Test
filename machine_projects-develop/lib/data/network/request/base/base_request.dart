import 'package:dio/dio.dart';
import 'package:machine/data/network/request/base/method.dart';
import 'package:machine/data/network/request/base/request_data.dart';

abstract class BaseRequest {
  BaseRequest({
    required this.method,
    required this.path,
    this.data,
  });

  RequestData? data;
  int? sendTimeout;
  int? receiveTimeout;
  int? connectTimeout;
  CancelToken? cancelToken;
  ProgressCallback? onReceiveProgress;
  ProgressCallback? onSendProgress;
  Map<String, dynamic>? extra;
  Map<String, dynamic>? headers;
  ResponseType? responseType;
  String? contentType;
  ValidateStatus? validateStatus;
  bool? receiveDataWhenStatusError;
  bool? followRedirects;
  int? maxRedirects;
  RequestEncoder? requestEncoder;
  ResponseDecoder? responseDecoder;
  ListFormat? listFormat;
  bool? setRequestContentTypeWhenNoPayload;

  String get baseUrl;

  String path;
  Method method;

  RequestOptions get options => RequestOptions(
        method: method.name,
        sendTimeout: Duration(seconds: sendTimeout ?? 0),
        receiveTimeout: Duration(seconds: receiveTimeout ?? 0),
        connectTimeout: Duration(seconds: connectTimeout ?? 0),
        data: data?.data,
        path: path,
        queryParameters: data?.queryParameters,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        baseUrl: baseUrl,
        extra: extra,
        headers: headers,
        responseType: responseType,
        contentType: contentType,
        validateStatus: validateStatus,
        receiveDataWhenStatusError: receiveDataWhenStatusError,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
        requestEncoder: requestEncoder,
        responseDecoder: responseDecoder,
        listFormat: listFormat,
        setRequestContentTypeWhenNoPayload: setRequestContentTypeWhenNoPayload,
      );
}
