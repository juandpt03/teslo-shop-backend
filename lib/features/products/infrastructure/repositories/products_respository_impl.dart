import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDataSource dataSource;

  ProductsRepositoryImpl(this.dataSource);
  @override
  Future<Producto> createUpdateProduct(Map<String, dynamic> productLike) {
    return dataSource.createUpdateProduct(productLike);
  }

  @override
  Future<Producto> getProductById(String id) {
    return dataSource.getProductById(id);
  }

  @override
  Future<List<Producto>> getProductByPage({int limit = 10, int offset = 0}) {
    return dataSource.getProductByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Producto>> searchProductByTerm(String term) {
    return dataSource.searchProductByTerm(term);
  }
}
