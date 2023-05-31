class Recommendations {
  Recommendations({this.advise});

  Recommendations.fromJson(Map<String, dynamic> json) {
    advise = json['advise'].cast<String>();
  }

  List<String>? advise;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['advise'] = advise;
    return data;
  }
}
