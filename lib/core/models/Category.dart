import 'package:equatable/equatable.dart';

class Category extends Equatable {
    Category({
        required this.id,
        required this.name,
    }): super();

    final String id;
    final String name;

    Category copyWith({
        String? id,
        String? name,
    }) {
        return Category(
            id: id ?? this.id,
            name: name ?? this.name,
        );
        }

    factory Category.fromJson(Map<String, dynamic> json){ 
        return Category(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
    );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };

    @override
    String toString(){
    return '$id, $name';
    }

    @override
    List<Object?> get props => [
    id, name, ];
}
