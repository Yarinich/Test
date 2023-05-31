import 'package:machine/data/database/hive_provider.dart';
import 'package:machine/data/network/request/base/base_request.dart';
import 'package:machine/data/network/request/cr_request/cr_request_constants.dart';

export 'package:machine/data/network/request/base/method.dart';
export 'package:machine/data/network/request/base/request_data.dart';

class CRRequest extends BaseRequest {
  CRRequest({
    required super.method,
    required super.path,
    super.data,
  });

  bool get isTokenize => true;

  @override
  String get baseUrl => '';

  @override
  int? get connectTimeout => CRRequestConstants.serverTimeout;

  @override
  int? get sendTimeout => CRRequestConstants.serverTimeout;

  @override
  int? get receiveTimeout => CRRequestConstants.serverTimeout;

  @override
  String? get contentType => CRRequestConstants.contentType;

  @override
  Map<String, dynamic>? get headers {
    final map = <String, dynamic>{};
    if (isTokenize) {
      map[CRRequestConstants.authorization] = HiveProvider.instance.user?.email;
    }

    return map;
  }
}
