import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/network/apis/car_api.dart';
import 'package:machine/data/network/requests/get_car_info_request.dart';
import 'package:machine/pages/cars/bloc/car_event.dart';
import 'package:machine/pages/cars/bloc/car_state.dart';
import 'package:machine/utils/extensions/emitter_ext.dart';
import 'package:machine/utils/mixins/logout_bloc_mixin.dart';

class CarsBloc extends BaseBloc with LogoutBlocMixin {
  CarsBloc() {
    on<GetCarInfoEvent>(
      (event, emit) => emit.async(_getCarInfo()),
    );
  }

  final _carApi = CarApi();

  Stream<BaseState> _getCarInfo() {
    return doAsync(
      () => _carApi.getCarInfo(GetCarInfoRequest()),
      onComplete: ReceivedCarInfoState.new,
    );
  }
}
