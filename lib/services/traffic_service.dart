import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps_app/models/list_model.dart';
import 'package:maps_app/models/models.dart';

import 'package:maps_app/services/services.dart';

class TrafficService {
  final Dio _dioTraffic;
  final Dio _dioPlaces;
  final Dio _dioApi;

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlacesUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';
  final String _baseApiUrl =
      "https://rutas-app-ae221-default-rtdb.firebaseio.com";

  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor()),
        _dioPlaces = Dio()..interceptors.add(PlacesInterceptor()),
        _dioApi = Dio()
          ..interceptors.add(RequestInterceptor())
          ..interceptors
              .add(LogInterceptor(requestBody: true, responseBody: true));

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coorsString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseTrafficUrl/driving/$coorsString';

    final resp = await _dioTraffic.get(url);

    final data = TrafficResponse.fromMap(resp.data);

    return data;
  }

  Future<List<Feature>> getResultsByQuery(
      LatLng proximity, String query) async {
    if (query.isEmpty) return [];

    final url = '$_basePlacesUrl/$query.json';

    final resp = await _dioPlaces.get(
      url,
      queryParameters: {
        'proximity': '${proximity.longitude},${proximity.latitude}',
        'limit': 7
      },
    );

    final jsonResponse = json.encode(resp.data);

    final placesResponse = PlacesResponse.fromJson(jsonResponse);

    return placesResponse.features;
  }

  Future<Feature> getInformationByCoors(LatLng coors) async {
    final url = '$_basePlacesUrl/${coors.longitude},${coors.latitude}.json';
    final resp = await _dioPlaces.get(url, queryParameters: {'limit': 1});

    final jsonResponse = json.encode(resp.data);

    final placesResponse = PlacesResponse.fromJson(jsonResponse);

    return placesResponse.features[0];
  }

  Future<List<ListModel>> getRoutesList() async {
    final url = '$_baseApiUrl/list.json';
    final resp = await _dioApi.get(url);

    List<ListModel> list = [];

    log(json.encode(resp.data));

    final listMap = listModelFromJson(json.encode(resp.data));

    listMap.map((key, value) {
      list.add(value);
      return MapEntry(key, value);
    });

    return list;
  }

  Future registerRoutesList(RouteModel route) async {
    try {
      final url = '$_baseApiUrl/list.json';
      final resp = await _dioApi.post(
        url,
        data: route.toJson(),
      );

      return resp.data;
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
