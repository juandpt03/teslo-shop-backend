import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import 'providers.dart';

//StateNotifierProvider

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, String productId) {
  final productsRepository = ref.watch(productRepositoryProvider);
  return ProductNotifier(
      productsRepository: productsRepository, productId: productId);
});

//Notifier

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;

  ProductNotifier({
    required this.productsRepository,
    required String productId,
  }) : super(ProductState(id: productId)) {
    loadProduct();
  }
  Producto _newEmptyProduct() {
    return Producto(
      id: 'new',
      title: '',
      price: 0,
      description: '',
      slug: '',
      stock: 0,
      sizes: [],
      gender: 'men',
      tags: [],
      images: [],
    );
  }

  Future<void> loadProduct() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(
          isLoading: false,
          product: _newEmptyProduct(),
        );
        return;
      }
      final product = await productsRepository.getProductById(state.id);
      state = state.copyWith(
        isLoading: false,
        product: product,
      );
    } catch (e) {
      print(e);
    }
  }
}

//clase
class ProductState {
  final String id;
  final Producto? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });
  ProductState copyWith({
    String? id,
    Producto? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
