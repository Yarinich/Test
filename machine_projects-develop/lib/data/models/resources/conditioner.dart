import 'package:machine/pages/resource_info/models/conditioning_state.dart';

class Conditioner {
  Conditioner({
    this.status,
    this.state,
    this.power,
    this.workTemperature,
  });

  Conditioner.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    state = ConditioningState.values.firstWhere(
      (state) => state.backendValue == json['state'],
    );
    power = json['power'];
    workTemperature = json['workTemperature'];
  }

  bool? status;
  ConditioningState? state;
  int? power;
  int? workTemperature;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['state'] = state?.backendValue;
    data['power'] = power;
    data['workTemperature'] = workTemperature;
    return data;
  }
}
