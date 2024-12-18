class GetCarsDetailsModel {
    GetCarsDetailsModel({
        this.status,
        this.message,
        this.imageCount,
        this.specCount,
        this.internalCount,
        this.safetyCount,
        this.data,
    });

    int? status;
    String? message;
    int? imageCount;
    int? specCount;
    int? internalCount;
    int? safetyCount;
    Data? data;

    factory GetCarsDetailsModel.fromJson(Map<String, dynamic> json) => GetCarsDetailsModel(
        status: json["status"],
        message: json["message"],
        imageCount: json["imageCount"],
        specCount: json["specCount"],
        internalCount: json["internalCount"],
        safetyCount: json["safetyCount"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "imageCount": imageCount,
        "specCount": specCount,
        "internalCount": internalCount,
        "safetyCount": safetyCount,
        "data": data!.toJson(),
    };
}

class Data {
    Data({
        this.name,
        this.images,
        this.internalSpecifications,
        this.features,
        this.safetyFeatures,
    });

    String? name;
    List<String>? images;
    List<String>? internalSpecifications;
    List<String>? features;
    List<String>? safetyFeatures;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        images: List<String>.from(json["images"].map((x) => x)),
        internalSpecifications: List<String>.from(json["Internal Specifications"].map((x) => x)),
        features: List<String>.from(json["Features"].map((x) => x)),
        safetyFeatures: List<String>.from(json["Safety Features"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "InternalSpecifications": List<dynamic>.from(internalSpecifications!.map((x) => x)),
        "Features": List<dynamic>.from(features!.map((x) => x)),
        "SafetyFeatures": List<dynamic>.from(safetyFeatures!.map((x) => x)),
    };
}
