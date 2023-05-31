import 'package:machine/constants.dart';
import 'package:machine/data/models/user_model.dart';
import 'package:machine/data/network/request/cr_request/cr_request.dart';

class SignUpRequest extends CRRequest {
  SignUpRequest(this.user)
      : super(
          path: 'registration',
          method: Method.post,
        );

  final UserModel user;

  @override
  bool get isTokenize => false;

  @override
  String get baseUrl => serverBaseURL;

  @override
  RequestData? get data => RequestData.body(user.toJson());
}
