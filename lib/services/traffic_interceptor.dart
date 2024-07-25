import 'package:dio/dio.dart';

class TrafficInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1IjoiZnJhbmNpc3BlcmFsdGEwNSIsImEiOiJjbHoxZTczNXEwOHFuMnFwbjN3cW5meHhiIn0.yWOCEt2eYMQUn_yX70theQ';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': accessToken
    });

    options.validateStatus = (status) => status! < 500;

    super.onRequest(options, handler);
  }
}

class RequestInterceptor extends InterceptorsWrapper {
  RequestInterceptor();

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
  }
}
