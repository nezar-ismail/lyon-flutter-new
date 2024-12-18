class AvailableCarCompanyModel {
    AvailableCarCompanyModel({
        this.status,
        this.data,
        this.currency
    });

    int? status;
    List<AvaiCarPri>? data;
    String? currency;

    factory AvailableCarCompanyModel.fromJson(Map<String, dynamic> json) => AvailableCarCompanyModel(
        status: json["status"],
        data: List<AvaiCarPri>.from(json["data"].map((x) => AvaiCarPri.fromJson(x))),
        currency: json["currency"]
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "currency":currency
    };
}

class AvaiCarPri {
    AvaiCarPri({
        this.dailyPrice,
        this.monthlyPrice,
        this.vehicle,
        this.thumbnail,
        this.id,
        this.carId
    });

    num? dailyPrice;
    num? monthlyPrice;
    String? vehicle;
    String? thumbnail;
    String? id;
    String? carId;

    factory AvaiCarPri.fromJson(Map<String, dynamic> json) => AvaiCarPri(
        dailyPrice: json["daily_price"],
        monthlyPrice: json["monthly_price"],
        vehicle: json["vehicle"],
        thumbnail: json["thumbnail"],
        id: json["id"],
        carId: json["car_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "daily_price": dailyPrice,
        "monthly_price": monthlyPrice,
        "vehicle": vehicle,
        "thumbnail": thumbnail,
         "car_id": carId,
    };
}
