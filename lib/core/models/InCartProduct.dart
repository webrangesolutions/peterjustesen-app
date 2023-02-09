import 'package:equatable/equatable.dart';

class InCartProduct extends Equatable {
  final String id;
  final String category;
  final String description;
  final DateTime? created_on;
  final String price;
  final String thumbnail;
  final String title;
  final String variant;
  int amount;
  InCartProduct({
    required this.id,
    required this.category,
    required this.description,
    this.created_on,
    required this.price,
    required this.thumbnail,
    required this.title,
    required this.variant,
    required this.amount,
  }) : super();

  InCartProduct copyWith({
    String? id,
    String? category,
    String? description,
    String? price,
    String? thumbnail,
    String? title,
    String? variant,
    int? amount,
  }) {
    return InCartProduct(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      variant: variant ?? this.variant,
      amount: amount ?? this.amount,
    );
  }

  factory InCartProduct.fromJson(Map<String, dynamic> json) {
    return InCartProduct(
      id: json["id"] ?? "",
      category: json["category"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      title: json["title"] ?? "",
      variant: json["variant"] ?? "",
      amount: json["amount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "description": description,
        "price": price,
        "thumbnail": thumbnail,
        "title": title,
        "variant": variant,
        "amount": amount,
      };

  @override
  String toString() {
    return '$id, $category, $description, $created_on, $price, $thumbnail, $title, $variant $amount';
  }

  @override
  List<Object?> get props => [
        id,
        category,
        description,
        created_on,
        price,
        thumbnail,
        title,
        variant,
        amount,
      ];
}
