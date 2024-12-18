
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

OrderDetailsProgramModel welcomeFromJson(String str) => OrderDetailsProgramModel.fromJson(json.decode(str));

String welcomeToJson(OrderDetailsProgramModel data) => json.encode(data.toJson());

class OrderDetailsProgramModel {
    OrderDetailsProgramModel({
        this.status,
        this.error,
        this.data,
    });

    int? status;
    String? error;
    Data? data;

    factory OrderDetailsProgramModel.fromJson(Map<String, dynamic> json) => OrderDetailsProgramModel(
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
        this.trip,
        this.totalPrice,
        this.vehicleType,
        this.vehicleImage,
        this.currency,
        this.paymentMethod,
    });

    String? id;
    DateTime? orderDate;
    String? name;
    String? phone;
    String? email;
    String? service;
    String? status;
    List<Trip>? trip;
    String? totalPrice;
    String? vehicleType;
    String? vehicleImage;
    String? currency;
    String? paymentMethod;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        orderDate: DateTime.parse(json["orderDate"]),
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        service: json["service"],
        status: json["status"],
        trip: List<Trip>.from(json["trip"].map((x) => Trip.fromJson(x))),
        totalPrice: json["totalPrice"],
        vehicleType: json["vehicleType"],
        vehicleImage: json["vehicleImage"],
        currency: json["currency"],
        paymentMethod: json["paymentMethod"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "orderDate": orderDate.toString(),
        "name": name,
        "phone": phone,
        "email": email,
        "service": service,
        "status": status,
        "trip": List<dynamic>.from(trip!.map((x) => x.toJson())),
        "totalPrice": totalPrice,
        "vehicleType": vehicleType,
        "vehicleImage": vehicleImage,
        "currency": currency,
        "paymentMethod": paymentMethod,
    };
}

class Trip {
    Trip({
        this.destination,
        this.date,
        this.time,
    });

    String? destination;
    String? date;
    String? time;

    factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        destination: json["Destination"],
        date: json["Date"],
        time: json["Time"],
    );

    Map<String, dynamic> toJson() => {
        "Destination": destination,
        "Date": date,
        "Time": time,
    };
}
