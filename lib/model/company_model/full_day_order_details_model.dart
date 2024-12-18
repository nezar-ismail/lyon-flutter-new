class FullDayOrderDetailsCompanyModel {
    FullDayOrderDetailsCompanyModel({
        this.status,
        this.error,
        this.data,
        this.currency
    });

    int? status;
    String? error;
    Data? data;
    String? currency;

    factory FullDayOrderDetailsCompanyModel.fromJson(Map<String, dynamic> json) => FullDayOrderDetailsCompanyModel(
        status: json["status"],
        error: json["error"],
        data: Data.fromJson(json["data"]),
        currency:json["currency"]
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": data!.toJson(),
        "currency":currency
    };
}

class Data {
    Data({
        this.id,
        this.orderType,
        this.companyId,
        this.startDate,
        this.endDate,
        this.phoneNumber,
        this.projectName,
        this.status,
        this.numberOfDay,
        this.totalPrice,
        this.pricePerDay,
        this.vehicleType,
        this.createIn,
        this.comanyName,
        this.customerName,
        this.vehicleImagePath,
        this.numberOfVehicle
    });

    String? id;
    String? orderType;
    String? companyId;
    String? startDate;
    String? endDate;
    String? phoneNumber;
    String? projectName;
    String? status;
    int? numberOfDay;
    String? totalPrice;
    String? pricePerDay;
    String? vehicleType;
    String? createIn;
    String? comanyName;
    String? customerName;
    String? vehicleImagePath;
    String? numberOfVehicle;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        orderType: json["OrderType"],
        companyId: json["CompanyId"],
        startDate: json["StartDate"],
        endDate: json["EndDate"],
        phoneNumber: json["PhoneNumber"],
        projectName: json["ProjectName"],
        status: json["status"],
        numberOfDay: json["NumberOfDay"],
        totalPrice: json["totalPrice"],
        pricePerDay: json["PricePerDay"],
        vehicleType: json["VehicleType"],
        createIn: json["CreateIn"],
        comanyName: json["comanyName"],
        customerName: json["customerName"],
        vehicleImagePath:json["ImagePath"],
        numberOfVehicle:json["NumberOfVehicle"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "OrderType": orderType,
        "CompanyId": companyId,
        "StartDate": startDate.toString(),
        "EndDate": endDate.toString(),
        "PhoneNumber": phoneNumber,
        "ProjectName": projectName,
        "status": status,
        "NumberOfDay": numberOfDay,
        "totalPrice": totalPrice,
        "PricePerDay": pricePerDay,
        "VehicleType": vehicleType,
        "CreateIn": createIn.toString(),
        "comanyName": comanyName,
        "customerName": customerName,
        "ImagePath":vehicleImagePath,
        "NumberOfVehicle":numberOfVehicle
    };
}
