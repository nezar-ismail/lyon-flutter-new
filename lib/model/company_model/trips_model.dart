import 'dart:convert';

Trips tripsFromJson(String str) => Trips.fromJson(json.decode(str));

String tripsToJson(Trips data) => json.encode(data.toJson());

class Trips {
  List<ListElement> list;
  String phone;
  String startTime;
  String startDate;
  String name;
  String vechileType;
  String token;
  int mobile;
  double totalPrice;
  String projectName;

  Trips({
    required this.list,
    required this.phone,
    required this.startTime,
    required this.startDate,
    required this.name,
    required this.vechileType,
    required this.token,
    required this.mobile,
    required this.totalPrice,
    required this.projectName,
  });

  factory Trips.fromJson(Map<String, dynamic> json) => Trips(
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
        phone: json["phone"],
        startTime: json["startTime"],
        startDate: json["startDate"],
        name: json["name"],
        vechileType: json["vechileType"],
        token: json["token"],
        mobile: json["mobile"],
        totalPrice: json["totalPrice"],
        projectName: json["projectName"],
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "phone": phone,
        "startTime": startTime,
        "startDate": startDate,
        "name": name,
        "vechileType": vechileType,
        "token": token,
        "mobile": mobile,
        "totalPrice": totalPrice,
        "projectName": projectName,
      };
}

class ListElement {
  String? destination;
  String? location;
  String? customerName;
  String? phoneNumber;
  String? date;
  String? time;
  double? price;
  String? currency;
  String? note;

  ListElement({
    this.destination,
    this.location,
    this.customerName,
    this.phoneNumber,
    this.date,
    this.time,
    this.price,
    this.currency,
    this.note,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        destination: json["Destination"],
        location: json["Location"],
        customerName: json["customerName"],
        phoneNumber: json["phoneNumber"],
        date: json["Date"],
        time: json["Time"],
        price: json["price"],
        currency: json["currency"],
        note: json["Note"],
      );

  Map<String, dynamic> toJson() => {
        "Destination": destination,
        "Location": location,
        "customerName": customerName,
        "phoneNumber": phoneNumber,
        "Date": date,
        "Time": time,
        "price": price,
        "currency": currency,
        "Note": note,
      };

  @override
  String toString() {
    return "Destination: $destination\nLocation: $location\nCustomer Name: $customerName\nPhone Number: $phoneNumber\nDate: $date\nTime: $time\nPrice: $price\nCurrency: $currency\nNote: $note";
  }

  //Copy with
  ListElement copyWith({
    String? destination,
    String? location,
    String? customerName,
    String? phoneNumber,
    String? date,
    String? time,
    double? price,
    String? currency,
    String? note,
  }) =>
      ListElement(
        destination: destination ?? this.destination,
        location: location ?? this.location,
        customerName: customerName ?? this.customerName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        date: date ?? this.date,
        time: time ?? this.time,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        note: note ?? this.note,
      );
}
