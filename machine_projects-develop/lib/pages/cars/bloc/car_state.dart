import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/models/car.dart';

class ReceivedCarInfoState extends BaseState {
  const ReceivedCarInfoState(this.car);

  final Car? car;
}
