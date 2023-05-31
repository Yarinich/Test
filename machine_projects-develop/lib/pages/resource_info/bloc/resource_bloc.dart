import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/network/apis/resource_api.dart';
import 'package:machine/data/network/requests/resources/get_resources_request.dart';
import 'package:machine/pages/resource_info/bloc/resource_event.dart';
import 'package:machine/pages/resource_info/bloc/resource_state.dart';
import 'package:machine/utils/extensions/emitter_ext.dart';
import 'package:machine/utils/mixins/logout_bloc_mixin.dart';

class ResourceBloc extends BaseBloc with LogoutBlocMixin {
  ResourceBloc() : super() {
    on<GetResourceInfoEvent>(
      (_, emit) => emit.async(_getResourceInfo()),
    );
  }

  final _resourceApi = ResourceApi();

  Stream<BaseState> _getResourceInfo() {
    return doAsync(
      () => _resourceApi.getResource(GetResourcesRequest()),
      onComplete: ReceivedResourcesState.new,
    );
  }
}
