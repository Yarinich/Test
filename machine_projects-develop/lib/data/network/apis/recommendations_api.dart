import 'package:machine/data/models/recommendation.dart';
import 'package:machine/data/network/clients/rest_client.dart';
import 'package:machine/data/network/requests/get_recommendations_request.dart';

class RecommendationsApi {
  final _client = RestClient.instance;

  Future<Recommendations> getRecommendations(
          GetRecommendationsRequest request) =>
      _client.request(request).then(
            (value) => Recommendations.fromJson(value.data),
          );
}
