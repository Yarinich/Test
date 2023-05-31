import 'package:machine/data/models/car.dart';
import 'package:machine/data/network/clients/rest_client.dart';
import 'package:machine/data/network/requests/get_car_info_request.dart';

class CarApi {
  final _client = RestClient.instance;

  Future<Car?> getCarInfo(GetCarInfoRequest request) =>
      _client.request(request).then((value) => Car.fromJson(value.data));
}
