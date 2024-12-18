import 'dart:convert';

List<TransportationFromTo> transportationFromToFromJson(String str) =>
    List<TransportationFromTo>.from(
        json.decode(str).map((x) => TransportationFromTo.fromJson(x)));

String transportationFromToToJson(List<TransportationFromTo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransportationFromTo {
  final String id;
  final String start;
  final String locations;
  final String end;
  final String startAr;
  final String locationsAr;
  final String endAr;
  final String carPrice;
  final String vanPrice;
  final String coasterPrice;
  final String busPrice;
  final String active;
  final String requireTicket;
  final DateTime createdOn;
  final String ways;
  final String carPriceMulti;
  final String vanPriceMulti;
  final String busPriceMulti;
  final String coasterPriceMulti;
  final String currency;

  TransportationFromTo({
    required this.id,
    required this.start,
    required this.locations,
    required this.end,
    required this.startAr,
    required this.locationsAr,
    required this.endAr,
    required this.carPrice,
    required this.vanPrice,
    required this.coasterPrice,
    required this.busPrice,
    required this.active,
    required this.requireTicket,
    required this.createdOn,
    required this.ways,
    required this.carPriceMulti,
    required this.vanPriceMulti,
    required this.busPriceMulti,
    required this.coasterPriceMulti,
    required this.currency,
  });

  factory TransportationFromTo.fromJson(Map<String, dynamic> json) =>
      TransportationFromTo(
        id: json["id"],
        start: json["start"],
        locations: json["locations"],
        end: json["end"],
        startAr: json["start_ar"],
        locationsAr: json["locations_ar"],
        endAr: json["end_ar"],
        carPrice: json["carPrice"],
        vanPrice: json["vanPrice"],
        coasterPrice: json["coasterPrice"],
        busPrice: json["busPrice"],
        active: json["active"],
        requireTicket: json["requireTicket"],
        createdOn: DateTime.parse(json["createdOn"]),
        ways: json["ways"],
        carPriceMulti: json["carPriceMulti"],
        vanPriceMulti: json["vanPriceMulti"],
        busPriceMulti: json["busPriceMulti"],
        coasterPriceMulti: json["coasterPriceMulti"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start": start,
        "locations": locations,
        "end": end,
        "start_ar": startAr,
        "locations_ar": locationsAr,
        "end_ar": endAr,
        "carPrice": carPrice,
        "vanPrice": vanPrice,
        "coasterPrice": coasterPrice,
        "busPrice": busPrice,
        "active": active,
        "requireTicket": requireTicket,
        "createdOn": createdOn.toIso8601String(),
        "ways": ways,
        "carPriceMulti": carPriceMulti,
        "vanPriceMulti": vanPriceMulti,
        "busPriceMulti": busPriceMulti,
        "coasterPriceMulti": coasterPriceMulti,
        "currency": currency,
      };
}
