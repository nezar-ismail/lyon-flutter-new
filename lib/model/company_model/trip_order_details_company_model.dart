// To parse this JSON data, do
//
//     final tripOrderDetailsCompanyModel = tripOrderDetailsCompanyModelFromJson(jsonString);

import 'dart:convert';

TripOrderDetailsCompanyModel tripOrderDetailsCompanyModelFromJson(String str) =>
    TripOrderDetailsCompanyModel.fromJson(json.decode(str));

String tripOrderDetailsCompanyModelToJson(TripOrderDetailsCompanyModel data) =>
    json.encode(data.toJson());

class TripOrderDetailsCompanyModel {
  int status;
  String error;
  Data data;
  String currency;

  TripOrderDetailsCompanyModel({
    required this.status,
    required this.error,
    required this.data,
    required this.currency,
  });

  factory TripOrderDetailsCompanyModel.fromJson(Map<String, dynamic> json) =>
      TripOrderDetailsCompanyModel(
        status: json["status"],
        error: json["error"],
        data: Data.fromJson(json["data"]),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": data.toJson(),
        "currency": currency,
      };
}

class Data {
  String id;
  DateTime orderDate;
  String name;
  String phone;
  String email;
  String service;
  String status;
  String totalPrice;
  String dataCustomerName;
  String projectName;
  String vehicleType;
  List<String> destinationArray;
  List<String> locationArray;
  List<String> dateArray;
  List<String> timeArray;
  List<String> customerName;
  List<String> customerNumber;

  Data({
    required this.id,
    required this.orderDate,
    required this.name,
    required this.phone,
    required this.email,
    required this.service,
    required this.status,
    required this.totalPrice,
    required this.dataCustomerName,
    required this.projectName,
    required this.vehicleType,
    required this.destinationArray,
    required this.locationArray,
    required this.dateArray,
    required this.timeArray,
    required this.customerName,
    required this.customerNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        orderDate: DateTime.parse(json["orderDate"]),
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        service: json["service"],
        status: json["status"],
        totalPrice: json["totalPrice"],
        dataCustomerName: json["customerName"],
        projectName: json["projectName"],
        vehicleType: json["vehicleType"],
        destinationArray:
            List<String>.from(json["destinationArray"].map((x) => x)),
        locationArray: List<String>.from(json["locationArray"].map((x) => x)),
        dateArray: List<String>.from(json["dateArray"].map((x) => x)),
        timeArray: List<String>.from(json["timeArray"].map((x) => x)),
        customerName: List<String>.from(json["CustomerName"].map((x) => x)),
        customerNumber: List<String>.from(json["CustomerNumber"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderDate": orderDate.toIso8601String(),
        "name": name,
        "phone": phone,
        "email": email,
        "service": service,
        "status": status,
        "totalPrice": totalPrice,
        "customerName": dataCustomerName,
        "projectName": projectName,
        "vehicleType": vehicleType,
        "destinationArray": List<dynamic>.from(destinationArray.map((x) => x)),
        "locationArray": List<dynamic>.from(locationArray.map((x) => x)),
        "dateArray": List<dynamic>.from(dateArray.map((x) => x)),
        "timeArray": List<dynamic>.from(timeArray.map((x) => x)),
        "CustomerName": List<dynamic>.from(customerName.map((x) => x)),
        "CustomerNumber": List<dynamic>.from(customerNumber.map((x) => x)),
      };
}
