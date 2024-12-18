// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<GetTransportationRoutes> welcomeFromJson(String str) => List<GetTransportationRoutes>.from(json.decode(str).map((x) => GetTransportationRoutes.fromJson(x)));

String welcomeToJson(List<GetTransportationRoutes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTransportationRoutes {
    GetTransportationRoutes({
        this.id,
        this.start,
        this.locations,
        this.end,
        this.carPrice,
        this.vanPrice,
        this.coasterPrice,
        this.busPrice,
        this.active,
        this.requireTicket,
        this.createdOn,
    });

    String? id;
    String? start;
    String? locations;
    String? end;
    String? carPrice;
    String? vanPrice;
    String? coasterPrice;
    String? busPrice;
    String? active;
    String? requireTicket;
    DateTime? createdOn;

    factory GetTransportationRoutes.fromJson(Map<String, dynamic> json) => GetTransportationRoutes(
        id: json["id"],
        start: json["start"],
        locations: json["locations"],
        end: json["end"],
        carPrice: json["carPrice"],
        vanPrice: json["vanPrice"],
        coasterPrice: json["coasterPrice"],
        busPrice: json["busPrice"],
        active: json["active"],
        requireTicket: json["requireTicket"],
        createdOn: DateTime.parse(json["createdOn"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "start": start,
        "locations": locations,
        "end": end,
        "carPrice": carPrice,
        "vanPrice": vanPrice,
        "coasterPrice": coasterPrice,
        "busPrice": busPrice,
        "active": active,
        "requireTicket": requireTicket,
        "createdOn": createdOn.toString(),
    };
}
