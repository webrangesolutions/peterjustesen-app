import 'package:equatable/equatable.dart';

class Product extends Equatable {
    Product({
        required this.id,
        required this.category,
        required this.description,
        required this.created_on,
        required this.images,
        required this.price,
        required this.isFavorite,
        required this.thumbnail,
        required this.title,
        required this.variants,
        required this.colors,
    }): super();

    final String id;
    final String category;
    final String description;
    final List<String> images;
    final DateTime created_on;
    final String price;
    final bool isFavorite;
    final String thumbnail;
    final String title;
    final List<String> variants;
    final List<String> colors;

    Product copyWith({
        String? id,
        String? category,
        String? description,
        List<String>? images,
        DateTime? created_on,
        String? price,
        bool? isFavorite,
        String? thumbnail,
        String? title,
        List<String>? variants,
        List<String>? colors,
    }) {
        return Product(
            id: id ?? this.id,
            category: category ?? this.category,
            description: description ?? this.description,
            images: images ?? this.images,
            created_on: created_on ?? this.created_on,
            price: price ?? this.price,
            isFavorite: isFavorite ?? this.isFavorite,
            thumbnail: thumbnail ?? this.thumbnail,
            title: title ?? this.title,
            variants: variants ?? this.variants,
            colors: colors ?? this.colors,

        );
        }

    factory Product.fromJson(Map<String, dynamic> json){ 
        return Product(
        id: json["id"] ?? "",
        category: json["category"] ?? "",
        description: json["description"] ?? "",
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        created_on: json["created_on"] == null ? DateTime.now() : DateTime.parse(json["created_on"]),
        price: json["price"] ?? "",
        isFavorite: json["isFavorite"] ?? false,
        thumbnail: json["thumbnail"] ?? "",
        title: json["title"] ?? "",
        variants: json["variants"] == null ? [] : List<String>.from(json["variants"]!.map((x) => x)),
        colors: json["variants"] == null ? [] : List<String>.from(json["variants"]!.map((x) => x)),
    );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "description": description,
        "images": List<String>.from(images.map((x) => x)),
        "created_on": created_on.toIso8601String(),
        "price": price,
        "isFavorite": isFavorite,
        "thumbnail": thumbnail,
        "title": title,
        "variants": List<String>.from(variants.map((x) => x)),
        "colors": List<String>.from(variants.map((x) => x)),
    };

    @override
    String toString(){
    return '$id, $category, $description, $images, $created_on, $price, $isFavorite, $thumbnail, $title, $variants, $colors';
    }

    @override
    List<Object?> get props => [
    id, category, description, images, created_on, price, isFavorite, thumbnail, title, variants, colors ];
}
