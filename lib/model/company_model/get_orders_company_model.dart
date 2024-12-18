class GetOrdersCompanyModel {
  GetOrdersCompanyModel({
    this.status,
    this.error,
    this.data,
  });

  int? status;
  String? error;
  List<Datum>? data;

  factory GetOrdersCompanyModel.fromJson(Map<String, dynamic> json) =>
      GetOrdersCompanyModel(
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
  Datum(
      {this.date,
      this.name,
      this.service,
      this.status,
      this.id,
      this.projectName,
      this.isRelayed,
      this.contractNumber,
      this.contractId});

  String? date;
  String? name;
  String? service;
  String? status;
  String? id;
  String? projectName;
  String? isRelayed;
  String? contractId;
  String? contractNumber;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      date: json["date"],
      name: json["name"],
      service: json["service"],
      status: json["status"],
      id: json["id"],
      projectName: json["projectName"],
      isRelayed: json["isRelayed"],
      contractId: json["ContractId"],
      contractNumber:json["contractNumber"]
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "name": name,
        "service": service,
        "status": status,
        "id": id,
        "projectName": projectName,
        "isRelayed": isRelayed,
        "ContractId": contractId,
        "contractNumber":contractNumber
      };
}
