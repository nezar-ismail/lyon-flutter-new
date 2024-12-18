// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

IsCarAvailable welcomeFromJson(String str) =>
    IsCarAvailable.fromJson(json.decode(str));

String welcomeToJson(IsCarAvailable data) => json.encode(data.toJson());

class IsCarAvailable {
  IsCarAvailable(
      {this.status,
      this.message,
      this.price,
      this.days,
      this.pricePerDay,
      this.currency,
      this.ashtray,
      this.carSeat,
      this.gasoline,
      this.smokingCar,
      this.insurance});

  int? status;
  String? message;
  int? price;
  int? days;
  int? pricePerDay;
  String? currency;
  int? gasoline;
  int? carSeat;
  int? smokingCar;
  int? ashtray;
  int? insurance;

  factory IsCarAvailable.fromJson(Map<String, dynamic> json) => IsCarAvailable(
      status: json["status"],
      message: json["message"],
      price: json["price"],
      days: json["days"],
      pricePerDay: json["pricePerDay"],
      currency: json["currency"],
      gasoline: json["gasoline"],
      carSeat: json["carSeat"],
      smokingCar: json["smokingCar"],
      ashtray: json["ashtray"],
      insurance: json["insurance"]);

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "price": price,
        "days": days,
        "pricePerDay": pricePerDay,
        "currency": currency,
        "gasoline": gasoline,
        "carSeat": carSeat,
        "smokingCar": smokingCar,
        "ashtray": ashtray,
        "insurance": insurance
      };
}
