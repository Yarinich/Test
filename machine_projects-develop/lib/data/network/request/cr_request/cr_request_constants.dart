import 'package:machine/data/network/request/cr_request/cr_request.dart';

extension CRRequestConstants on CRRequest {
  static const serverTimeout = 15000;
  static const contentType = 'application/json';
  static const authorization = 'Authorization';
  static const tokenType = 'Bearer';
}
