import 'package:aitie_demo/utils/repo_result_class.dart';

abstract class ProductRepository {
  Future<RepoResult> getAllProducts();
  Future<RepoResult> getProductDetails({required int productId});
}
