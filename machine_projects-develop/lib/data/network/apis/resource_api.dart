import 'package:machine/data/models/resources/resource_info.dart';
import 'package:machine/data/network/clients/rest_client.dart';
import 'package:machine/data/network/requests/resources/get_resources_request.dart';

class ResourceApi {
  final _client = RestClient.instance;

  Future<ResourceInfo?> getResource(GetResourcesRequest request) => _client
      .request(request)
      .then((value) => ResourceInfo.fromJson(value.data));
}
