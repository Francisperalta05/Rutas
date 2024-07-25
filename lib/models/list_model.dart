// To parse this JSON data, do
//
//     final listModel = listModelFromJson(jsonString);

import 'dart:convert';

Map<String, ListModel> listModelFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, ListModel>(k, ListModel.fromJson(v)));

String listModelToJson(Map<String, ListModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class ListModel {
  String description;
  double destinationLatitude;
  double destinationLongitude;
  double startLatitude;
  double startLongitude;
  String title;

  ListModel({
    required this.description,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.startLatitude,
    required this.startLongitude,
    required this.title,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
        description: json["description"],
        destinationLatitude: json["destinationLatitude"]?.toDouble(),
        destinationLongitude: json["destinationLongitude"]?.toDouble(),
        startLatitude: json["startLatitude"]?.toDouble(),
        startLongitude: json["startLongitude"]?.toDouble(),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "destinationLatitude": destinationLatitude,
        "destinationLongitude": destinationLongitude,
        "startLatitude": startLatitude,
        "startLongitude": startLongitude,
        "title": title,
      };
}
