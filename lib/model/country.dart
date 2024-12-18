class Country {
  Country({
    required this.city,
    required this.country,
    // required this.populationCounts,
  });

  String city;
  String country;
  // List<PopulationCount> populationCounts;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        city: json["city"],
        country: json["country"],
        // populationCounts: List<PopulationCount>.from(
        //     json["populationCounts"].map((x) => PopulationCount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        // "populationCounts":
        //     List<dynamic>.from(populationCounts.map((x) => x.toJson())),
      };
  @override
  String toString() {
    return "$city,$country";
  }
}

class PopulationCount {
  PopulationCount({
    required this.year,
    required this.value,
    required this.sex,
    required this.reliabilty,
  });

  // ignore: prefer_typing_uninitialized_variables
  var year;
  // ignore: prefer_typing_uninitialized_variables
  var value;
  // ignore: prefer_typing_uninitialized_variables
  var sex;
  // ignore: prefer_typing_uninitialized_variables
  var reliabilty;

  factory PopulationCount.fromJson(Map<String, dynamic> json) =>
      PopulationCount(
        year: json["year"].toString(),
        // ignore: prefer_null_aware_operators
        value: json["value"] == null ? null : json["value"].toString(),
        // ignore: prefer_null_aware_operators
        sex: json["sex"] == null ? null : json["sex"].toString(),
        // ignore: prefer_null_aware_operators
        reliabilty: json["reliabilty"] == null ? null : json["reliabilty"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        // ignore: prefer_if_null_operators
        "value": value == null ? null : value,
        // ignore: prefer_if_null_operators
        "sex": sex == null ? null : sex,
        // ignore: prefer_if_null_operators
        "reliabilty": reliabilty == null ? null : reliabilty,
      };
}
