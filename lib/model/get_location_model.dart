// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

GetLocationModel welcomeFromJson(String str) => GetLocationModel.fromJson(json.decode(str));

String welcomeToJson(GetLocationModel data) => json.encode(data.toJson());

class GetLocationModel {
    GetLocationModel({
        this.countryCode,
        this.countryName,
        this.city,
        this.postal,
        this.latitude,
        this.longitude,
        this.iPv4,
        this.state,
    });

    String? countryCode;
    String? countryName;
    dynamic city;
    dynamic postal;
    int? latitude;
    int? longitude;
    String? iPv4;
    dynamic state;

    factory GetLocationModel.fromJson(Map<String, dynamic> json) => GetLocationModel(
        countryCode: json["country_code"],
        countryName: json["country_name"],
        city: json["city"],
        postal: json["postal"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        iPv4: json["IPv4"],
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "country_name": countryName,
        "city": city,
        "postal": postal,
        "latitude": latitude,
        "longitude": longitude,
        "IPv4": iPv4,
        "state": state,
    };
}
