import 'package:machine/constants.dart';
import 'package:machine/data/network/request/cr_request/cr_request.dart';

class GetResourcesRequest extends CRRequest {
  GetResourcesRequest()
      : super(
          method: Method.post,
          path: 'resources',
        );

  @override
  String get baseUrl => machineBaseURL;
}
