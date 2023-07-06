import 'package:teslo_shop/features/products/domain/entities/producto.dart';

abstract class ProductsRepository {
  Future<List<Producto>> getProductByPage({int limit = 10, int offset = 0});
  Future<Producto> getProductById(String id);
  Future<List<Producto>> searchProductByTerm(String term);
  Future<Producto> createUpdateProduct(Map<String, dynamic> productLike);
}
