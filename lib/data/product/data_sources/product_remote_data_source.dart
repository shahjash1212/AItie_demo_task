import 'package:aitie_demo/constants/api_end_point_or_path.dart';
import 'package:aitie_demo/constants/api_status.dart';
import 'package:aitie_demo/utils/api_result_class.dart';
import 'package:aitie_demo/utils/dio_client.dart';
import 'package:flutter/foundation.dart';

abstract class ProductRemoteDataSource {
  Future<ApiResult> getAllProducts();
  Future<ApiResult> getProductDetails({required int productId});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<ApiResult> getAllProducts() async {
    try {
      ApiResult result = await DioClient.get(ApiEndPoint.products);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return const ApiFailure(statusCode: ApiStatus.s1);
    }
  }

  @override
  Future<ApiResult> getProductDetails({required int productId}) async {
    try {
      ApiResult result = await DioClient.get('');
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return const ApiFailure(statusCode: ApiStatus.s1);
    }
  }
}
