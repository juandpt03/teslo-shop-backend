import 'package:riverpod/riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/datasources/products_datasource_impl.dart';
import 'package:teslo_shop/features/products/infrastructure/repositories/products_respository_impl.dart';

final productRepositoryProvider = Provider<ProductsRepository>((ref) {
  final acessToken = ref.watch(authProvider).user?.token ?? '';
  final productRepository =
      ProductsRepositoryImpl(ProductsDataSourceImpl(acessToken: acessToken));
  return productRepository;
});
