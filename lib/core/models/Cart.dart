// cart model which has a list of products and also variation for each product
import 'package:equatable/equatable.dart';
import 'package:peterjustesen/core/models/InCartProduct.dart';

class Cart extends Equatable {
  Cart({
    required this.in_cart_products,
  });

  final List<InCartProduct> in_cart_products;

  Cart copyWith({
    List<InCartProduct>? in_cart_products,
  }) {
    return Cart(
      in_cart_products: in_cart_products ?? this.in_cart_products,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        in_cart_products: json["in_cart_products"] == null ? [] : List<InCartProduct>.from(json["in_cart_products"]!.map((x) => InCartProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "in_cart_products": List<dynamic>.from(in_cart_products.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Cart{in_cart_products: $in_cart_products}';
  }

  @override
  List<Object?> get props => [
        in_cart_products,
      ];
}
