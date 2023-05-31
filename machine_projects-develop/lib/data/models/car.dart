class Car {
  Car({
    this.id,
    required this.brand,
    required this.model,
    required this.classification,
    required this.engine,
    required this.consumption,
    required this.air,
  });

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    model = json['model'];
    classification = json['classification'];

    engine = json['engine'];
    consumption = json['consumption'];
    air = json['air'];
  }

  int? id;
  String? brand;
  String? model;
  String? classification;
  String? engine;
  String? consumption;
  String? air;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['model'] = model;
    data['classification'] = classification;
    data['engine'] = engine;
    data['consumption'] = consumption;
    data['air'] = air;
    data.removeWhere((key, value) => value == null);

    return data;
  }
}
