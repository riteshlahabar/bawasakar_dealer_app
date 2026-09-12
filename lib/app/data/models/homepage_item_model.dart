class HomepageItemModel {
  const HomepageItemModel({
    required this.id,
    this.title = '',
    this.subtitle = '',
    this.description = '',
    this.highlightText = '',
    this.discountText = '',
    this.validityText = '',
    this.couponCode = '',
    this.buttonText = '',
    this.backgroundColor = '',
    this.textColor = '',
    this.imageUrl,
    this.mobileImageUrl,
  });

  final int id;

  final String title;
  final String subtitle;
  final String description;

  final String highlightText;
  final String discountText;
  final String validityText;

  final String couponCode;
  final String buttonText;

  final String backgroundColor;
  final String textColor;

  final String? imageUrl;
  final String? mobileImageUrl;

  factory HomepageItemModel.fromJson(Map<String, dynamic> json) {
    return HomepageItemModel(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      highlightText: json['highlight_text']?.toString() ?? '',
      discountText: json['discount_text']?.toString() ?? '',
      validityText: json['validity_text']?.toString() ?? '',
      couponCode: json['coupon_code']?.toString() ?? '',
      buttonText: json['button_text']?.toString() ?? '',
      backgroundColor: json['background_color']?.toString() ?? '',
      textColor: json['text_color']?.toString() ?? '',
      imageUrl: _image(json, 'image_url'),
      mobileImageUrl: _image(json, 'mobile_image_url'),
    );
  }

  String? get bestImageUrl {
    if (mobileImageUrl != null && mobileImageUrl!.trim().isNotEmpty) {
      return mobileImageUrl;
    }

    return imageUrl;
  }

  static int _asInt(dynamic value) {
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String? _image(Map<String, dynamic> json, String key) {
    final value = json[key]?.toString().trim() ?? '';

    if (value.isNotEmpty && value != 'null') {
      return value;
    }

    return null;
  }
}
