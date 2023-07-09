import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/enviroment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import '../errors/product_errors.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDataSourceImpl extends ProductsDataSource {
  late final Dio dio;
  final String acessToken;

  ProductsDataSourceImpl({required this.acessToken})
      : dio = Dio(
          BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $acessToken'},
          ),
        );
  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap(
          {'file': MultipartFile.fromFileSync(path, filename: fileName)});
      final response = await dio.post('/files/product', data: data);
      return response.data['image'];
    } catch (e) {
      throw Exception;
    }
  }

  Future<List<String>> _uploadPhotos(List<String> photos) async {
    final photosToUpload =
        photos.where((element) => element.contains('/')).toList();
    final photosToIgnore =
        photos.where((element) => !element.contains('/')).toList();

    final List<Future<String>> uploadJob =
        photosToUpload.map(_uploadFile).toList();
    final newImages = await Future.wait(uploadJob);

    return [...newImages, ...photosToIgnore];
  }

  @override
  Future<Producto> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url =
          (productId == null) ? '/products' : '/products/$productId';

      productLike.remove('id');
      productLike['images'] = await _uploadPhotos(productLike['images']);

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(
          method: method,
        ),
      );
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception;
    }
  }

  @override
  Future<Producto> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Producto>> getProductByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Producto> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }

  @override
  Future<List<Producto>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
