// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserTrips {
  final String? destination;
  final String? date;
  final String? time;
  final String? price;
  final String? requireTicket;
  final String? currency;

  const UserTrips({
    this.destination,
    this.date,
    this.time,
    this.price,
    this.requireTicket,
    this.currency,
  });

  UserTrips copyWith({
    String? destination,
    String? date,
    String? time,
    String? price,
    String? requireTicket,
    String? currency,
  }) {
    return UserTrips(
      destination: destination ?? this.destination,
      date: date ?? this.date,
      time: time ?? this.time,
      price: price ?? this.price,
      requireTicket: requireTicket ?? this.requireTicket,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'destination': destination,
      'date': date,
      'time': time,
      'price': price,
      'requireTicket': requireTicket,
      'currency': currency
    };
  }

  factory UserTrips.fromMap(Map<String, dynamic> map) {
    return UserTrips(
      destination: map['destination'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      price: map['price'] as String,
      requireTicket: map['requireTicket'] as String,
      currency: map['currency'] as String
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTrips.fromJson(String source) => UserTrips.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserTrips(destination: $destination, date: $date, time: $time, price: $price, requireTicket: $requireTicket, currency: $currency)';
  }

  @override
  bool operator ==(covariant UserTrips other) {
    if (identical(this, other)) return true;
  
    return 
      other.destination == destination &&
      other.date == date &&
      other.time == time &&
      other.price == price &&
      other.currency == currency &&
      other.requireTicket == requireTicket;
  }

  @override
  int get hashCode {
    return destination.hashCode ^
      date.hashCode ^
      time.hashCode ^
      price.hashCode ^
      currency.hashCode ^
      requireTicket.hashCode;
  }
}
