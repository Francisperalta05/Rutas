class RouteModel {
  final String title;
  final String description;
  final double startLatitude;
  final double startLongitude;
  final double destinationLatitude;
  final double destinationLongitude;

  RouteModel({
    required this.title,
    required this.description,
    required this.startLatitude,
    required this.startLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        startLatitude: json["startLatitude"] ?? 0,
        startLongitude: json["startLongitude"] ?? 0,
        destinationLatitude: json["destinationLatitude"] ?? 0,
        destinationLongitude: json["destinationLongitude"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "startLatitude": startLatitude,
        "startLongitude": startLongitude,
        "destinationLatitude": destinationLatitude,
        "destinationLongitude": destinationLongitude,
      };
}
