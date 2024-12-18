// To parse this JSON data, do
//
//     final availableCarsModle = availableCarsModleFromJson(jsonString);

import 'dart:convert';

AvailableCarsModle availableCarsModleFromJson(String str) =>
    AvailableCarsModle.fromJson(json.decode(str));

String availableCarsModleToJson(AvailableCarsModle data) =>
    json.encode(data.toJson());

class AvailableCarsModle {
  int status;
  String currency;
  List<Datum> data;

  AvailableCarsModle({
    required this.status,
    required this.currency,
    required this.data,
  });

  factory AvailableCarsModle.fromJson(Map<String, dynamic> json) =>
      AvailableCarsModle(
        status: json["status"],
        currency: json["currency"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "currency": currency,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String vehicleNumber;
  String carId;
  String vehicleManufacturer;
  String vehicleName;
  String vehicleModel;
  String companyName;
  String vinNo;
  String engineNumber;
  String registrationNumber;
  DateTime licenseExpiryDate;
  String annualRental;
  String soldCar;
  String image;
  String type;
  int price;
  String currency;

  Datum({
    required this.id,
    required this.vehicleNumber,
    required this.carId,
    required this.vehicleManufacturer,
    required this.vehicleName,
    required this.vehicleModel,
    required this.companyName,
    required this.vinNo,
    required this.engineNumber,
    required this.registrationNumber,
    required this.licenseExpiryDate,
    required this.annualRental,
    required this.soldCar,
    required this.image,
    required this.type,
    required this.price,
    required this.currency,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        vehicleNumber: json["vehicle_number"],
        carId: json["car_id"],
        vehicleManufacturer: json["vehicle_manufacturer"],
        vehicleName: json["vehicle_name"],
        vehicleModel: json["vehicle_model"],
        companyName: json["company_name"],
        vinNo: json["vin_no"],
        engineNumber: json["engine_number"],
        registrationNumber: json["registration_number"],
        licenseExpiryDate: DateTime.parse(json["license_expiry_date"]),
        annualRental: json["annual_rental"],
        soldCar: json["sold_car"],
        image: json["image"],
        type: json["type"],
        price: json["price"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_number": vehicleNumber,
        "car_id": carId,
        "vehicle_manufacturer": vehicleManufacturer,
        "vehicle_name": vehicleName,
        "vehicle_model": vehicleModel,
        "company_name": companyName,
        "vin_no": vinNo,
        "engine_number": engineNumber,
        "registration_number": registrationNumber,
        "license_expiry_date":
            "${licenseExpiryDate.year.toString().padLeft(4, '0')}-${licenseExpiryDate.month.toString().padLeft(2, '0')}-${licenseExpiryDate.day.toString().padLeft(2, '0')}",
        "annual_rental": annualRental,
        "sold_car": soldCar,
        "image": image,
        "type": type,
        "price": price,
        "currency": currency,
      };
}
