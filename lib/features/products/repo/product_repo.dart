import 'package:aitie_demo/constants/api_status.dart';
import 'package:aitie_demo/features/products/model/product_response.dart';
import 'package:aitie_demo/features/products/service/product_service.dart';
import 'package:aitie_demo/utils/api_result_class.dart';
import 'package:aitie_demo/utils/repo_result_class.dart';
import 'package:flutter/foundation.dart';

class ProductRepository {
  final ProductService _productService = ProductService();
  Future<RepoResult> getAllProducts() async {
    try {
      ApiResult result = await _productService.getAllProducts();
      if (result is ApiSuccess) {
        List<ProductResponse> data = List.from(
          result.data.map((x) => ProductResponse.fromMap(x)),
        );
        return RepoSuccess(data: data);
      } else {
        return RepoFailure(
          errorMessage: (result as ApiFailure).errorMessage,
          statusCode: result.statusCode,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return RepoFailure(errorMessage: e.toString(), statusCode: ApiStatus.s1);
    }
  }
}
