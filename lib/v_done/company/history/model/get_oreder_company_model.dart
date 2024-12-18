class GetOrdersCompanyModel {
  List<OrderData>? data;

  GetOrdersCompanyModel({this.data});

  GetOrdersCompanyModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderData {
  String? id;
  String? contractId;
  String? contractNumber;
  String? projectName;
  String? date;
  String? service;
  String? status;
  String? isRelayed;
  int? totalUsers;

  OrderData({
    this.id,
    this.contractId,
    this.contractNumber,
    this.projectName,
    this.date,
    this.service,
    this.status,
    this.isRelayed,
    this.totalUsers,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    contractId = json['contract_id']?.toString();
    contractNumber = json['contract_number']?.toString();
    projectName = json['project_name']?.toString();
    date = json['date']?.toString();
    service = json['service']?.toString();
    status = json['status']?.toString();
    isRelayed = json['is_relayed']?.toString();
    totalUsers = json['total_users'] is int 
        ? json['total_users'] 
        : int.tryParse(json['total_users']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['contract_id'] = contractId;
    data['contract_number'] = contractNumber;
    data['project_name'] = projectName;
    data['date'] = date;
    data['service'] = service;
    data['status'] = status;
    data['is_relayed'] = isRelayed;
    data['total_users'] = totalUsers;
    return data;
  }
}