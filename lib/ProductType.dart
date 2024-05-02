import 'dart:convert';
import 'package:http/http.dart' as http;


class ProductType {
  final String name;
  ProductType({required this.name});

  factory ProductType.fromJson(String json) {
    return ProductType(name: json);
  }
  String get _name{return name;}
  bool isEmpty(){
    if(name == null) {
      return true;
    }
    return false;
  }
  bool equals(ProductType productType){
    if(name == productType.name) {
      return true;
    }
    return false;
  }

}


class ProductTypeRepository {
  Future<List<ProductType>>? getProductTypes() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<ProductType> productTypes = jsonData.map((json) => ProductType.fromJson(json)).toList();
      return productTypes;
    }
    else {
      throw Exception('Failed to load product categories');
    }
  }
}

