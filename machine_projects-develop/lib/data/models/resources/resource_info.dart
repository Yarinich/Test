import 'package:machine/data/models/resources/conditioner.dart';
import 'package:machine/data/models/resources/sensor.dart';

class ResourceInfo {
  ResourceInfo({
    this.conditioner,
    this.innerSensor,
    this.outerSensor,
  });

  ResourceInfo.fromJson(Map<String, dynamic> json) {
    conditioner = json['conditioner'] != null
        ? Conditioner.fromJson(json['conditioner'])
        : null;
    innerSensor = json['innerSensor'] != null
        ? Sensor.fromJson(json['innerSensor'])
        : null;
    outerSensor = json['outerSensor'] != null
        ? Sensor.fromJson(json['outerSensor'])
        : null;
  }

  Conditioner? conditioner;
  Sensor? innerSensor;
  Sensor? outerSensor;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conditioner != null) {
      data['conditioner'] = conditioner?.toJson();
    }
    if (innerSensor != null) {
      data['innerSensor'] = innerSensor?.toJson();
    }
    if (outerSensor != null) {
      data['outerSensor'] = outerSensor?.toJson();
    }
    return data;
  }
}
