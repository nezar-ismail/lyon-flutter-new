// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

GetOrderDetailsRentalModel welcomeFromJson(String str) => GetOrderDetailsRentalModel.fromJson(json.decode(str));

String welcomeToJson(GetOrderDetailsRentalModel data) => json.encode(data.toJson());

class GetOrderDetailsRentalModel {
    GetOrderDetailsRentalModel({
        this.status,
        this.error,
        this.data,
    });

    int? status;
    String? error;
    Data? data;

    factory GetOrderDetailsRentalModel.fromJson(Map<String, dynamic> json) => GetOrderDetailsRentalModel(
        status: json["status"],
        error: json["error"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": data!.toJson(),
    };
}

class Data {
    Data({
        this.id,
        this.orderDate,
        this.name,
        this.phone,
        this.email,
        this.service,
        this.status,
        this.startDate,
        this.endDate,
        this.carId,
        this.carName,
        this.carImage,
        this.startLocation,
        this.endLocation,
        this.pricePerDay,
        this.totalPrice,
        this.paymentMethod,
        this.currency,
        this.endTime,
        this.startTime,
        this.extraItem
    });

    String? id;
    String? orderDate;
    String? name;
    String? phone;
    String? email;
    String? service;
    String? status;
    String? startDate;
    String? endDate;
    String? carId;
    String? carName;
    String? carImage;
    String? startLocation;
    String? endLocation;
    String? pricePerDay;
    String? totalPrice;
    String? paymentMethod;
    String? currency;
    String? startTime;
    String? endTime;
    String? extraItem;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        orderDate: json["orderDate"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        service: json["service"],
        status: json["status"],
        startDate:json["startDate"],
        endDate: json["endDate"],
        carId: json["carID"],
        carName: json["carName"],
        carImage: json["carImage"],
        startLocation: json["startLocation"],
        endLocation: json["endLocation"],
        pricePerDay: json["pricePerDay"],
        totalPrice: json["totalPrice"],
        paymentMethod: json["paymentMethod"],
        currency: json["currency"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        extraItem:json["extraItem"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "orderDate": orderDate.toString(),
        "name": name,
        "phone": phone,
        "email": email,
        "service": service,
        "status": status,
        "startDate": startDate,
        "endDate": endDate,
        "carID": carId,
        "carName": carName,
        "carImage": carImage,
        "startLocation": startLocation,
        "endLocation": endLocation,
        "pricePerDay": pricePerDay,
        "totalPrice": totalPrice,
        "paymentMethod":paymentMethod,
        "currency":currency,
        "startTime":startTime,
        "endTime":endTime,
        "extraItem":extraItem
    };
}
