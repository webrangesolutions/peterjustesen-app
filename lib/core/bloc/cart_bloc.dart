import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:peterjustesen/core/models/InCartProduct.dart';

// *EVENTS
class CartEvent {
  CartEvent();
}

class AddToCartEvent extends CartEvent {
  final String id;
  final String variant;
  final int amount;
  AddToCartEvent({required this.id, required this.variant, required this.amount}) : super();
}

class RemoveFromCartEvent extends CartEvent {
  final int index;
  RemoveFromCartEvent(this.index) : super();
}

class IncrementFromIndexEvent extends CartEvent {
  final int index;
  IncrementFromIndexEvent(this.index) : super();
}

class DecrementFromIndexEvent extends CartEvent {
  final int index;
  DecrementFromIndexEvent(this.index) : super();
}

// *STATE
class CartState extends Equatable {
  final List<InCartProduct> in_cart_products;

  CartState({
    required this.in_cart_products,
  }) : super();

  List<InCartProduct> get products => in_cart_products;

  factory CartState.initial() {
    return CartState(in_cart_products: []);
  }

  @override
  List<Object> get props => [in_cart_products];

  CartState copyWith({
    List<InCartProduct>? in_cart_products,
  }) {
    return CartState(
      in_cart_products: in_cart_products ?? this.in_cart_products,
    );
  }

  CartState fromJson(Map<String, dynamic> json) {
    return CartState(
      in_cart_products: json['in_cart_products'] != null ? (json['in_cart_products'] as List).map((i) => InCartProduct.fromJson(i)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['in_cart_products'] = this.in_cart_products.map((v) => v.toJson()).toList();
    return data;
  }
}

class CartEmpty extends CartState {
  CartEmpty() : super(in_cart_products: []);
}

class CartLoaded extends CartState {
  CartLoaded({required in_cart_products}) : super(in_cart_products: in_cart_products);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartEmpty()) {
    on<AddToCartEvent>((event, emit) async {
      try {
        var added = await FirebaseCartService.getProductById(event.id, event.variant, event.amount);
        emit(
          state.copyWith(
            in_cart_products: [...state.in_cart_products, added!],
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: $e");
        throw e;
      }
    });

    on<RemoveFromCartEvent>((event, emit) {
      emit(
        state.copyWith(
          in_cart_products: state.in_cart_products.where((element) => state.in_cart_products.indexOf(element) != event.index).toList(),
        ),
      );
    });

    on<IncrementFromIndexEvent>((event, emit) {
      emit(
        state.copyWith(
          in_cart_products: state.in_cart_products.map((e) {
            if (state.in_cart_products.indexOf(e) == event.index) {
              return e.copyWith(amount: e.amount + 1);
            } else {
              return e;
            }
          }).toList(),
        ),
      );
    });

    on<DecrementFromIndexEvent>((event, emit) {
      if (state.in_cart_products[event.index].amount == 1) {
        return;
      }
      emit(
        state.copyWith(
          in_cart_products: state.in_cart_products.map((e) {
            if (state.in_cart_products.indexOf(e) == event.index) {
              return e.copyWith(amount: e.amount - 1);
            } else {
              return e;
            }
          }).toList(),
        ),
      );
    });
  }

  double getTotalPrice() {
    double total = 0.0;
    state.in_cart_products.forEach((element) {
      total += double.parse("10.30") * element.amount;
    });
    return total;
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) {
    return json['in_cart_products'] != null ? CartLoaded(in_cart_products: (json['in_cart_products'] as List).map((i) => InCartProduct.fromJson(i)).toList()) : CartEmpty();
  }

  @override
  Map<String, dynamic>? toJson(CartState state) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['in_cart_products'] = state.in_cart_products.map((v) => v.toJson()).toList();
    return data;
  }
}

class FirebaseCartService {
  static InCartProduct? getProductById(String id, String variant, int amount) {
    FirebaseFirestore.instance.collection("products").doc(id).get().then((value) {
      if (value.data() == null) {
        throw Exception("Product not found");
      }
      return InCartProduct(
        id: id,
        title: value.data()!["title"],
        description: value.data()!["description"],
        thumbnail: value.data()!["thumbnail"][0],
        price: value.data()!["price"],
        category: value.data()!["category"],
        created_on: DateTime.fromMicrosecondsSinceEpoch(value.data()!["created_on"].microsecondsSinceEpoch),
        amount: amount,
        variant: variant,
      );
    });
  }
}
