import 'package:aitie_demo/constants/api_status.dart';
import 'package:aitie_demo/utils/api_result_class.dart';
import 'package:aitie_demo/utils/dio_client.dart';
import 'package:flutter/foundation.dart';

class ProductService {
  Future<ApiResult> getAllProducts() async {
    try {
      ApiResult result = await DioClient.get('');
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return const ApiFailure(statusCode: ApiStatus.s1);
    }
  }

  Future<ApiResult> getProductsDetails({required int productId}) async {
    try {
      ApiResult result = await DioClient.get('');
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return const ApiFailure(statusCode: ApiStatus.s1);
    }
  }
}
