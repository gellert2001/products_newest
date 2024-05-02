import 'package:json_annotation/json_annotation.dart';
import 'package:products_newest/VoteCounter.dart';

import 'VoteBloc.dart';


@JsonSerializable()
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  @JsonKey(ignore: true)
  final VoteBloc voteBloc;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    required this.voteBloc
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'] is int ? (json['price'] as int).toDouble() : json['price'],
      discountPercentage: json['discountPercentage'] is int ? (json['discountPercentage'] as int).toDouble() : json['discountPercentage'],
      rating: json['rating'] is int ? (json['rating'] as int).toDouble() : json['rating'],
      stock: json['stock'],
      brand: json['brand'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images']),
      voteBloc: VoteBloc(VoteCounter(0,0)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
      'votecounter': {'upvote': voteBloc.votecounter.upvote, 'downvote': voteBloc.votecounter.downvote},
    };
  }
}

