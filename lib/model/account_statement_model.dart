import 'dart:convert';

AccountStatementModel welcomeFromJson(String str) =>
    AccountStatementModel.fromJson(json.decode(str));

String welcomeToJson(AccountStatementModel data) => json.encode(data.toJson());

class AccountStatementModel {
  AccountStatementModel(
      {this.status,
      this.paymentsArray,
      this.totalBalance,
      this.totalDebit,
      this.totalCredit,
      this.currencyValue,
      this.currency});

  int? status;
  List<PaymentsArray>? paymentsArray;
  int? totalBalance;
  int? totalDebit;
  int? totalCredit;
  String? currencyValue;
  String? currency;

  factory AccountStatementModel.fromJson(Map<String, dynamic> json) =>
      AccountStatementModel(
        status: json["status"],
        paymentsArray: List<PaymentsArray>.from(
            json["paymentsArray"].map((x) => PaymentsArray.fromJson(x))),
        totalBalance: json["totalBalance"],
        totalDebit: json["totalDebit"],
        totalCredit: json["totalCredit"],
        currencyValue: json["CurrencyValue"],
        currency: json["Currency"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "paymentsArray":
            List<dynamic>.from(paymentsArray!.map((x) => x.toJson())),
        "totalBalance": totalBalance,
        "totalDebit": totalDebit,
        "totalCredit": totalCredit,
        "CurrencyValue": currencyValue,
        "Currency": currency
      };
}

class PaymentsArray {
  PaymentsArray(
      {this.id,
      this.total,
      this.service,
      this.number,
      this.balance,
      this.date,
      this.details,
      this.credit,
      this.debit});

  String? id;
  String? total;
  String? service;
  String? number;
  String? balance;
  String? debit;
  String? credit;
  String? date;
  String? details;

  factory PaymentsArray.fromJson(Map<String, dynamic> json) => PaymentsArray(
        id: json["id"],
        total: json["total"],
        service: json["service"],
        number: json["number"],
        balance: json["balance"],
        debit: json["debit"],
        credit: json["credit"],
        date: json["date"],
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total": total,
        "service": service,
        "number": number,
        "balance": balance,
        "debit": debit,
        "credit": credit,
        "date": date.toString(),
        "details": details,
      };
}
