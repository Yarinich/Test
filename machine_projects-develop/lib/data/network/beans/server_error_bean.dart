import 'dart:convert';

/// Server response model for errors.
class ServerErrorBean {
  ServerErrorBean({
    this.sV,
    this.code,
    this.stacktrace,
  });

  ServerErrorBean.fromJson(Map<String, dynamic> json) {
    sV = json['_v'];
    code = json['code'];
    if (json['errors'] != null) {
      errors =
          jsonDecode(json['errors']).listFrom(json['errors'], ErrorsBean());
    }
    stacktrace = json['stacktrace']?.cast<String>();
  }

  String? sV;
  String? code;
  List<ErrorsBean>? errors;
  List<String>? stacktrace;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['__v'] = sV;
    data['code'] = code;
    data['errors'] = errors?.map((e) => e.toJson());
    data['stacktrace'] = stacktrace;

    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class ErrorsBean {
  ErrorsBean({this.key, this.message});

  ErrorsBean.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    message = json['message'];
  }

  String? key;
  String? message;

  ErrorsBean fromJson(Map<String, dynamic> json) {
    return ErrorsBean.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['key'] = key;

    return data;
  }
}
