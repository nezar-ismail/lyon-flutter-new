// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

GetCarsModel welcomeFromJson(String str) => GetCarsModel.fromJson(json.decode(str));

String welcomeToJson(GetCarsModel data) => json.encode(data.toJson());

class GetCarsModel {
    GetCarsModel({
        this.status,
        this.message,
        this.count,
        this.data,
    });

    int? status;
    String? message;
    int? count;
    List<Datum>? data;

    factory GetCarsModel.fromJson(Map<String, dynamic> json) => GetCarsModel(
        status: json["status"],
        message: json["message"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "count": count,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.thumbnail,
        this.name,
        this.price,
        this.currency,
    });

    int? id;
    String? thumbnail;
    String? name;
    int? price;
    String? currency;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        thumbnail: json["thumbnail"],
        name: json["name"],
        price: json["price"],
        currency: json["currency"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "thumbnail": thumbnail,
        "name": name,
        "price": price,
        "currency": currency,
    };
}

// enum Currency { GBP }

// final currencyValues = EnumValues({
//     "GBP": Currency.GBP
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         if (reverseMap == null) {
//             reverseMap = map.map((k, v) => new MapEntry(v, k));
//         }
//         return reverseMap;
//     }
// }
