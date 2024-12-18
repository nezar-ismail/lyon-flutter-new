// To parse this JSON data, do
//
//     final bracket = bracketFromJson(jsonString);

import 'dart:convert';

OfferModel bracketFromJson(String str) => OfferModel.fromJson(json.decode(str));

String bracketToJson(OfferModel data) => json.encode(data.toJson());

class OfferModel {
    int status;
    String message;
    List<Datum> data;

    OfferModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String title;
    String image;
    dynamic createdOn;
    String body;

    Datum({
        required this.id,
        required this.title,
        required this.image,
        required this.createdOn,
        required this.body,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        createdOn: json["createdOn"],
        body: json["body"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "createdOn": createdOn,
        "body": body,
    };
}
