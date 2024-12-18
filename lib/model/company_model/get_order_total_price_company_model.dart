class GetOrderPriceCompanyModel {
    GetOrderPriceCompanyModel({
        this.status,
        this.data,
        this.currency
    });

    int? status;
    Data? data;
    String? currency;

    factory GetOrderPriceCompanyModel.fromJson(Map<String, dynamic> json) => GetOrderPriceCompanyModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        currency:json["currency"]
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
        "currency":currency
    };
}

class Data {
    Data({
        this.numberOfDays,
        this.pricePerDay,
        this.totalPrice,
    });

    num? numberOfDays;
    num? pricePerDay;
    num? totalPrice;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        numberOfDays: json["numberOfDays"],
        pricePerDay: json["pricePerDay"],
        totalPrice: json["totalPrice"],
    );

    Map<String, dynamic> toJson() => {
        "numberOfDays": numberOfDays,
        "pricePerDay": pricePerDay,
        "totalPrice": totalPrice,
    };
}
