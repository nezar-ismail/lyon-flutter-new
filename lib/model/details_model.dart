// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DetailsModel welcomeFromJson(String str) => DetailsModel.fromJson(json.decode(str));

String welcomeToJson(DetailsModel data) => json.encode(data.toJson());

class DetailsModel {
    DetailsModel({
        this.id,
        this.thumbnail,
        this.engineSize,
        this.luggage,
        this.people,
        this.gear,
        this.backImage,
        this.interiorImage,
        this.sideImage,
        this.count,
        this.createdOn,
        this.name,
        this.internalSpecs,
        this.features,
        this.safetyFeatures,
    });

    String? id;
    String? thumbnail;
    String? engineSize;
    String? luggage;
    String? people;
    String? gear;
    String? backImage;
    String? interiorImage;
    String? sideImage;
    String? count;
    DateTime? createdOn;
    String? name;
    String? internalSpecs;
    String? features;
    String? safetyFeatures;

    factory DetailsModel.fromJson(Map<String, dynamic> json) => DetailsModel(
        id: json["id"],
        thumbnail: json["thumbnail"],
        engineSize: json["engineSize"],
        luggage: json["luggage"],
        people: json["people"],
        gear: json["gear"],
        backImage: json["backImage"],
        interiorImage: json["interiorImage"],
        sideImage: json["sideImage"],
        count: json["count"],
        createdOn: DateTime.parse(json["createdOn"]),
        name: json["name"],
        internalSpecs: json["internalSpecs"],
        features: json["features"],
        safetyFeatures: json["safetyFeatures"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "thumbnail": thumbnail,
        "engineSize": engineSize,
        "luggage": luggage,
        "people": people,
        "gear": gear,
        "backImage": backImage,
        "interiorImage": interiorImage,
        "sideImage": sideImage,
        "count": count,
        "createdOn": createdOn.toString(),
        "name": name,
        "internalSpecs": internalSpecs,
        "features": features,
        "safetyFeatures": safetyFeatures,
    };
}
