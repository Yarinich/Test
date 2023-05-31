import 'package:machine/constants.dart';
import 'package:machine/data/network/request/cr_request/cr_request.dart';

class GetCarInfoRequest extends CRRequest {
  GetCarInfoRequest()
      : super(
          method: Method.get,
          path: 'getCarInfo',
        );

  @override
  String get baseUrl => serverBaseURL;
}
