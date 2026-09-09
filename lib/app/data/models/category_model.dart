class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.assetPath,
  });

  final int id;
  final String name;
  final String slug;
  final String? imageUrl;
  final String? assetPath;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? json['category_name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
    );
  }

  static int _asInt(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
}
