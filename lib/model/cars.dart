class Cars {
  Cars({
    required this.status,
    required this.error,
    required this.data,
  });

  String status;
  String error;
  List<Datum> data;

  factory Cars.fromJson(Map<String, dynamic> json) => Cars(
    status: json["status"],
    error: json["error"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.image,
    required this.price
  });

  int id;
  String name;
  String image;
  int price;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] as int,
    name: json["name"],
    image: json["image"],
    price: json["price"] as int
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "price": price,
  };
}
