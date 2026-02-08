import 'package:aitie_demo/constants/api_status.dart';
import 'package:aitie_demo/data/product/data_sources/product_remote_data_source.dart';
import 'package:aitie_demo/data/product/models/product_response.dart';
import 'package:aitie_demo/domain/product/repositories/product_repository.dart';
import 'package:aitie_demo/utils/api_result_class.dart';
import 'package:aitie_demo/utils/repo_result_class.dart';
import 'package:flutter/foundation.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RepoResult> getAllProducts() async {
    try {
      ApiResult result = await remoteDataSource.getAllProducts();
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

  @override
  Future<RepoResult> getProductDetails({required int productId}) async {
    try {
      ApiResult result = await remoteDataSource.getProductDetails(
        productId: productId,
      );
      if (result is ApiSuccess) {
        ProductResponse data = ProductResponse.fromMap(result.data);
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
