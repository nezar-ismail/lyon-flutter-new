import 'dart:convert';

GetOrderDetailsTransportationModel welcomeFromJson(String str) =>
    GetOrderDetailsTransportationModel.fromJson(json.decode(str));

String welcomeToJson(GetOrderDetailsTransportationModel data) =>
    json.encode(data.toJson());

class GetOrderDetailsTransportationModel {
  GetOrderDetailsTransportationModel({
    this.status,
    this.error,
    this.data,
  });

  int? status;
  String? error;
  Data? data;

  factory GetOrderDetailsTransportationModel.fromJson(
          Map<String, dynamic> json) =>
      GetOrderDetailsTransportationModel(
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
  Data(
      {this.id,
      this.orderDate,
      this.name,
      this.phone,
      this.email,
      this.service,
      this.status,
      this.startDate,
      this.startTime,
      this.totalPrice,
      this.vehicleType,
      this.vehicleImage,
      this.destination,
      this.additionalNotes,
      this.currency,
      this.paymentMethod,
      this.waysType});

  String? id;
  String? orderDate;
  String? name;
  String? phone;
  String? email;
  String? service;
  String? status;
  String? startDate;
  String? startTime;
  String? totalPrice;
  String? vehicleType;
  String? vehicleImage;
  String? destination;
  String? additionalNotes;
  String? paymentMethod;
  String? currency;
  String? waysType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      id: json["id"],
      orderDate: json["orderDate"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      service: json["service"],
      status: json["status"],
      startDate: json["startDate"],
      startTime: json["startTime"],
      totalPrice: json["totalPrice"],
      vehicleType: json["vehicleType"],
      vehicleImage: json["vehicleImage"],
      destination: json["destination"],
      additionalNotes: json["additionalNotes"],
      paymentMethod: json["paymentMethod"],
      currency: json["currency"],
      waysType: json["waysType"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderDate": orderDate.toString(),
        "name": name,
        "phone": phone,
        "email": email,
        "service": service,
        "status": status,
        "startDate": startDate,
        "startTime": startTime,
        "totalPrice": totalPrice,
        "vehicleType": vehicleType,
        "vehicleImage": vehicleImage,
        "destination": destination,
        "additionalNotes": additionalNotes,
        "paymentMethod": paymentMethod,
        "currency": currency,
        "waysType": waysType
      };
}
