import 'dart:async';

import 'ProductModel.dart';

class SortingBloc{
  late StreamController<List<Product>> _sortedProductsController;

  Stream<List<Product>> get sortedProductsStream => _sortedProductsController.stream;

  SortingBloc() {
    _sortedProductsController = StreamController<List<Product>>.broadcast();
  }

  void sortProducts(List<Product> products) {
    products.sort((a, b) => b.voteBloc.votecounter.upvote.compareTo(a.voteBloc.votecounter.upvote));
    _sortedProductsController.add(products);
  }

  void dispose() {
    _sortedProductsController.close();
  }
}