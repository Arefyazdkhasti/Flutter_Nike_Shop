import 'package:dio/dio.dart';

import '../banner.dart';
import '../common/http_response_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);

  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validateResponse(response);
    final List<BannerEntity> banners = [];
    for (var jsonObject in (response.data as List)) {
      banners.add(BannerEntity.fromJson(jsonObject));
    }
    return banners;
  }
}
