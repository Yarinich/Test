import 'package:machine/constants.dart';
import 'package:machine/data/network/request/cr_request/cr_request.dart';

class GetRecommendationsRequest extends CRRequest {
  GetRecommendationsRequest()
      : super(
          path: 'recommendation',
          method: Method.get,
        );

  @override
  String get baseUrl => serverBaseURL;
}
