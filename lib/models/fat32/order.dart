// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Map<String, List<Order>> orderFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) => MapEntry<String, List<Order>>(
        k, List<Order>.from(v.map((x) => Order.fromJson(x)))));

Map<String, List<Order>> orderFromMap(Map<String, dynamic> data) =>
    Map.from(data).map((k, v) => MapEntry<String, List<Order>>(
        k, List<Order>.from(v.map((x) => Order.fromJson(x)))));

String orderToJson(Map<String, List<Order>> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(
        k, List<dynamic>.from(v.map((x) => x.toJson())))));

class Order {
  String name;
  int quantity;

  Order({
    this.name,
    this.quantity,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        name: json["name"] == null ? null : json["name"],
        quantity: json["quantity"] == null ? null : json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "quantity": quantity == null ? null : quantity,
      };
}
