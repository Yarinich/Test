import 'package:machine/data/network/clients/rest_client.dart';
import 'package:machine/data/network/requests/auth/sing_up_request.dart';

class AuthApi {
  final _client = RestClient.instance;

  Future<void> signUp(SignUpRequest request) => _client.request(request);
}
