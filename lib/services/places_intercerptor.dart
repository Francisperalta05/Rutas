import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1IjoiZnJhbmNpc3BlcmFsdGEwNSIsImEiOiJjbHoxZTczNXEwOHFuMnFwbjN3cW5meHhiIn0.yWOCEt2eYMQUn_yX70theQ';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
    });

    super.onRequest(options, handler);
  }
}
