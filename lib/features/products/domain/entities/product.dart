import 'package:teslo_app/features/auth/domain/domain.dart';
// import 'package:teslo_app/features/auth/infrastructure/infrastructure.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String slug;
  final int stock;
  final List<String> sizes;
  final String gender;
  final List<String> tags;
  final List<String> images;
  final User? user;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.slug,
    required this.stock,
    required this.sizes,
    required this.gender,
    required this.tags,
    required this.images,
    required this.user,
  });

  // factory Product.fromJson(Map<String, dynamic> json) => Product(
  //       id: json["id"],
  //       title: json["title"],
  //       price: json["price"],
  //       description: json["description"],
  //       slug: json["slug"],
  //       stock: json["stock"],
  //       sizes: List<String>.from(json["sizes"]),
  //       gender: json["gender"],
  //       tags: List<String>.from(json["tags"]),
  //       images: List<String>.from(json["images"]),
  //       user: UserMapper.userJsonToEntity(json["user"]),
  //     );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "title": title,
  //       "price": price,
  //       "description": description,
  //       "slug": slug,
  //       "stock": stock,
  //       "sizes": List<String>.from(sizes.map((x) => x)),
  //       "gender": gender,
  //       "tags": List<String>.from(tags.map((x) => tagValues.reverse[x])),
  //       "images": List<String>.from(images.map((x) => x)),
  //       "user": user.toJson(),
  //     };
}
