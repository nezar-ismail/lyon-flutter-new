// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

GetUserOrdersModel welcomeFromJson(String str) =>
    GetUserOrdersModel.fromJson(json.decode(str));

String welcomeToJson(GetUserOrdersModel data) => json.encode(data.toJson());

class GetUserOrdersModel {
  GetUserOrdersModel({
    this.status,
    this.error,
    this.data,
  });

  int? status;
  String? error;
  List<Datum>? data;

  factory GetUserOrdersModel.fromJson(Map<String, dynamic> json) =>
      GetUserOrdersModel(
        status: json["status"],
        error: json["error"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.timeLeft,
    this.name,
    this.service,
    this.status,
    this.id,
    this.isRelayed,
    this.contractId,
    this.paymentMethod,
    this.orderStartDate,
    this.statusAllowCancel,
    this.date
  });
  String? date;
  int? statusAllowCancel;
  String? id;
  String? timeLeft;
  String? name;
  String? service;
  String? status;
  String? isRelayed;
  String? contractId;
  String? paymentMethod;
  String? orderStartDate;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      timeLeft: json["timeLeft"],
      date: json['date'],
      name: json["name"],
      service: json["service"],
      status: json["status"],
      id: json["id"],
      isRelayed: json["isRelayed"],
      contractId: json['ContractId'],
      paymentMethod: json['paymentMethod'],
      orderStartDate: json['OrderStartDate'],
      statusAllowCancel: json['statusAllowCancel']
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "timeLeft": timeLeft,
        "name": name,
        "service": service,
        "status": status,
        "id": id,
        "isRelayed": isRelayed,
        "ContractId": contractId,
        "paymentMethod": paymentMethod,
        "OrderStartDate": orderStartDate,
        "statusAllowCancel": statusAllowCancel
      };
}
