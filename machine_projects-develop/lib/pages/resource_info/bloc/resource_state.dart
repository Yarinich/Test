import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/models/resources/resource_info.dart';

class ReceivedResourcesState extends BaseState {
  const ReceivedResourcesState(this.resourceInfo);

  final ResourceInfo? resourceInfo;
}
