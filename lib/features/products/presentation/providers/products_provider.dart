import 'package:riverpod/riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

//StateNotifie
final productsProvider =
    StateNotifierProvider<ProductNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productRepositoryProvider);
  return ProductNotifier(productsRepository: productsRepository);
});

//NOTIFIER
class ProductNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;
  ProductNotifier({required this.productsRepository}) : super(ProductsState()) {
    loadNextPage();
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
