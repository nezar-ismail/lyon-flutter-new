import 'dart:convert';

CreateOrderModel welcomeFromJson(String str) => CreateOrderModel.fromJson(json.decode(str));

String welcomeToJson(CreateOrderModel data) => json.encode(data.toJson());

class CreateOrderModel {
    CreateOrderModel({
        this.status,
        this.message,
    });

    int? status;
    String? message;

    factory CreateOrderModel.fromJson(Map<String, dynamic> json) => CreateOrderModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
