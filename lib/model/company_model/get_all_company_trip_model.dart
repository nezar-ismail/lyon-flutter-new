class GetAllCompanyTripModel {
    GetAllCompanyTripModel({
        this.location,

    });

    String? location;


    factory GetAllCompanyTripModel.fromJson(Map<String, dynamic> json) => GetAllCompanyTripModel(
        location: json["location"],

    );

    Map<String, dynamic> toJson() => {
        "location": location,
    };
}
