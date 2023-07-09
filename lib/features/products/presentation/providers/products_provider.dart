import 'package:riverpod/riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

//StateNotifie
final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});

//NOTIFIER
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;
  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    loadNextPage();
  }
  Future<bool> createorUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productsRepository.createUpdateProduct(productLike);
      final isProductInList =
          state.products.any((element) => element.id == product.id);
      if (!isProductInList) {
        state = state.copyWith(products: [product, ...state.products]);
        return true;
      }
      state = state.copyWith(
          products: state.products
              .map((element) => (element.id == product.id) ? product : element)
              .toList());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;
    state = state.copyWith(isLoading: true);
    final products = await productsRepository.getProductByPage(
        limit: state.limit, offset: state.offset);
    if (products.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }
    state = state.copyWith(
      isLoading: false,
      isLastPage: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );
  }
}

//STATE
class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Producto> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    final bool? isLastPage,
    final int? limit,
    final int? offset,
    final bool? isLoading,
    final List<Producto>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
      );
}
