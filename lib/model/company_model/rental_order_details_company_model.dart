class RentalOrderDetailsCompanyModel {
  RentalOrderDetailsCompanyModel(
      {this.status, this.error, this.data, this.currency});

  int? status;
  String? error;
  Data? data;
  String? currency;

  factory RentalOrderDetailsCompanyModel.fromJson(Map<String, dynamic> json) =>
      RentalOrderDetailsCompanyModel(
          status: json["status"] ?? "",
          error: json["error"],
          data: Data.fromJson(json["data"]),
          currency: json["currency"]);

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": data!.toJson(),
        "currency": currency
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
      this.endDate,
      this.endTime,
      this.carId,
      this.carName,
      this.carImage,
      this.pricePerDay,
      this.totalPrice,
      this.customerName,
      this.projectName});

  String? id;
  String? orderDate;
  String? name;
  String? phone;
  String? email;
  String? service;
  String? status;
  String? startDate;
  String? startTime;
  String? endDate;
  String? endTime;
  String? carId;
  String? carName;
  String? carImage;
  String? pricePerDay;
  String? totalPrice;
  String? customerName;
  String? projectName;

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
        endDate: json["endDate"],
        endTime: json["endTime"],
        carId: json["carID"],
        carName: json["carName"],
        carImage: json["carImage"],
        pricePerDay: json["pricePerDay"],
        totalPrice: json["totalPrice"],
        customerName: json["customerName"],
        projectName: json["projectName"],
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
        "startTime": startTime,
        "endDate": endDate,
        "endTime": endTime,
        "carID": carId,
        "carName": carName,
        "carImage": carImage,
        "pricePerDay": pricePerDay,
        "totalPrice": totalPrice,
        "customerName": customerName,
        "projectName": projectName,
      };
}
