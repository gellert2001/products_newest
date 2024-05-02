import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:products_newest/ProductModel.dart';
import 'package:http/http.dart' as http;
class ProductRepository {
  Future<List<Product>> getProducts() async {
    try {
      var response = await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {

        Map<String, dynamic> responseData = json.decode(response.body);

        List<dynamic> productsData = responseData['products'];

        List<Product> products = productsData.map((item) => Product.fromJson(item)).toList();

        return products;
      }
      else {
        throw Exception("failed to load products");
      }
    }catch (error) {
      if (kDebugMode) {
        print("Error in getProducts: $error");
      }
      throw Exception("Error in getProducts: $error");
    }
  }
}