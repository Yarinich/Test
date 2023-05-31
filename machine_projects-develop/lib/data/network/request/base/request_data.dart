class RequestData {
  RequestData.body(this.data);

  RequestData.query(this.queryParameters);

  RequestData.multi({this.data, this.queryParameters});

  dynamic data;
  Map<String, dynamic>? queryParameters;
}
