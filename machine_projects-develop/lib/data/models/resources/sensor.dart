class Sensor {
  Sensor({
    this.temperature,
    this.humidity,
  });

  Sensor.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'];
    humidity = json['humidity'];
  }

  int? temperature;
  int? humidity;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['temperature'] = temperature;
    data['humidity'] = humidity;

    return data;
  }
}
